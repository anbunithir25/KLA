import sys
import time

#Function to create fibonacci series based on user input
def fibonacci(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fibonacci(n-1) + fibonacci(n-2)

# condition:
#        1) check the user has entered a valid input , if it is not an integer it will print out the error message.
#        2) if it is an integer it will call the fibonacci function and creates fibonacci series based on user input.
#        3) if no input is given it will use time module and creates fibonacci sequence every 05 seconds
if len(sys.argv) > 1:
    try:
        n = int(sys.argv[1])
        print(f"Fibonacci({n}) = {fibonacci(n)}")
    except ValueError:
        print("Invalid input. Please enter a valid integer.")
else:
    a, b = 0, 1
    while True:
        print(a)
        a, b = b, a + b
        time.sleep(0.5)