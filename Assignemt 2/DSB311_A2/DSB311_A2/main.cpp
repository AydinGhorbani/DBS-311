#include <iostream>
#include </Users/aydinghorbani/Downloads/instantclient_19_16/sdk/include/occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

struct ShoppingCart
{
    int product_id{0};
    double price{0};
    int quantity{0};
};

const int MAX_CART_SIZE = 5; // the max number of items in one customer order

int mainMenu();
int customerLogin(Connection *conn, int customerId);
int addToCart(Connection *conn, struct ShoppingCart cart[]);
double findProduct(Connection *conn, int product_id);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection *conn, struct ShoppingCart cart[], int customerId, int productCount);
void displayOrderStatus(Connection *conn, int orderId, int customerId);
void cancelOrder(Connection *conn, int orderId, int customerId);

int main()
{
    // OCCI Variables
    Environment *env = nullptr;
    Connection *conn = nullptr;
    // Used Variables
    string str;
    string user = "[insert username here]";
    string pass = "[insert password here]";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
    try
    {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is Successful!" << endl;

        int customerId = 0;
        int mainChoice = 0;
        ShoppingCart cart[MAX_CART_SIZE];
        int productCount = 0;

        do
        {
            mainChoice = mainMenu();

            switch (mainChoice)
            {
            case 1:
                customerId = customerLogin(conn, customerId);
                break;
            case 2:
                if (customerId == 0)
                {
                    cout << "Please log in first." << endl;
                }
                else
                {
                    productCount = addToCart(conn, cart);
                }
                break;
            case 3:
                if (customerId == 0)
                {
                    cout << "Please log in first." << endl;
                }
                else if (productCount == 0)
                {
                    cout << "Your cart is empty." << endl;
                }
                else
                {
                    displayProducts(cart, productCount);
                }
                break;
            case 4:
                if (customerId == 0)
                {
                    cout << "Please log in first." << endl;
                }
                else if (productCount == 0)
                {
                    cout << "Your cart is empty." << endl;
                }
                else
                {
                    int orderStatus = checkout(conn, cart, customerId, productCount);
                    if (orderStatus == 1)
                    {
                        cout << "Order placed successfully!" << endl;
                        productCount = 0; // reset cart after successful checkout
                    }
                    else
                    {
                        cout << "Error placing order. Please try again." << endl;
                    }
                }
                break;
            case 5:
                if (customerId == 0)
                {
                    cout << "Please log in first." << endl;
                }
                else
                {
                    int orderId;
                    cout << "Enter order ID: ";
                    cin >> orderId;
                    displayOrderStatus(conn, orderId, customerId);
                }
                break;
            case 6:
                if (customerId == 0)
                {
                    cout << "Please log in first." << endl;
                }
                else
                {
                    int orderId;
                    cout << "Enter order ID to cancel: ";
                    cin >> orderId;
                    cancelOrder(conn, orderId, customerId);
                }
                break;
            case 7:
                cout << "Goodbye!" << endl;
                break;
            default:
                cout << "Invalid choice. Please try again." << endl;
                break;
            }
        } while (mainChoice != 7);

        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException &sqlExcp)
    {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }
    return 0;
}

int mainMenu()
{
    int choice;
    cout << "******************** Main Menu ********************" << endl;
    cout << "1) Login" << endl;
    cout << "2) Add Products to Cart" << endl;
    cout << "3) Display Cart" << endl;
    cout << "4) Checkout" << endl;
    cout << "5) Display Order Status" << endl;
    cout << "6) Cancel Order" << endl;
    cout << "7) Exit" << endl;
    cout << "Enter an option (1-7): ";
    cin >> choice;
    return choice;
}

int customerLogin(Connection *conn, int customerId)
{
    int inputId;
    cout << "Enter the customer ID: ";
    cin >> inputId;

    if (customerExists(conn, inputId))
    {
        cout << "Login successful!" << endl;
        return inputId;
    }
    else
    {
        cout << "The customer does not exist." << endl;
        return 0;
    }
}

int addToCart(Connection *conn, struct ShoppingCart cart[])
{
    int productCount = 0;
    char addMore;
    do
    {
        int productId;
        double productPrice;

        cout << "Enter the product ID: ";
        cin >> productId;

        if (productPrice > 0)
        {
            cout << "Product Price: " << productPrice << endl;
            cout << "Enter the product Quantity: ";
            cin >> cart[productCount].quantity;

            cart[productCount].product_id = productId;
            cart[productCount].price = productPrice;

            productCount++;

            cout << "Enter 1 to add more products or 0 to checkout: ";
            cin >> addMore;
        }
        else
        {
            cout << "Product not found. Please enter a valid product ID." << endl;
        }
    } while (addMore == '1');

    return productCount;
}

void displayProducts(struct ShoppingCart cart[], int productCount)
{
    cout << "------- Ordered Products ---------" << endl;
    for (int i = 0; i < productCount; ++i)
    {
        cout << "---Item " << i + 1 << endl;
        cout << "Product ID: " << cart[i].product_id << endl;
        cout << "Price: " << cart[i].price << endl;
        cout << "Quantity: " << cart[i].quantity << endl;
    }
    cout << "----------------------------------" << endl;
}
