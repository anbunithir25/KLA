FROM python:3.9

# Copying the Fibonacci python script into the container
COPY fibonacci.py /app/fibonacci.py

# Setting up the working directory
WORKDIR /app

# Command to run the Fibonacci script
ENTRYPOINT ["python", "fibonacci.py"]
CMD []
