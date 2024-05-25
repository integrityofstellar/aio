#!/bin/bash

# Define variables
REPO_URL="https://github.com/integrityofstellar/stellarcity-backend.git"
REPO_DIR="stellarcity-backend"
PYTHON_VERSION="python3"
VENV_DIR=".venv"
ENV_FILE=".env"
EXAMPLE_ENV_FILE="example.env"
REQUIREMENTS_FILE="requirements.txt"

# Step 1: Clone the repository
echo "Cloning the repository..."
git clone $REPO_URL

# Step 2: Navigate to the repository directory
cd $REPO_DIR || { echo "Failed to navigate to repository directory"; exit 1; }

# Step 3: Check if poetry is installed
if command -v poetry &> /dev/null
then
    echo "Poetry is installed."
    
    # Step 4: Install dependencies using Poetry
    echo "Installing dependencies with Poetry..."
    poetry install
else
    echo "Poetry is not installed."
    
    # Step 3: Create a virtual environment using venv
    echo "Creating virtual environment with venv..."
    $PYTHON_VERSION -m venv $VENV_DIR
    
    # Step 4: Activate the virtual environment
    echo "Activating virtual environment..."
    source $VENV_DIR/bin/activate

    # Step 5: Install dependencies
    echo "Installing dependencies with pip..."
    if [ -f $REQUIREMENTS_FILE ]; then
        pip install -r $REQUIREMENTS_FILE
    else
        echo "$REQUIREMENTS_FILE not found. Please provide a requirements.txt file or install Poetry."
        exit 1
    fi
fi

# Step 6: Create the .env file from the example.env file
if [ -f $EXAMPLE_ENV_FILE ]; then
    echo "Creating .env file..."
    cp $EXAMPLE_ENV_FILE $ENV_FILE
else
    echo "$EXAMPLE_ENV_FILE not found. Please create the .env file manually."
fi

# Step 7: Generate BCrypt salt and add/replace it in the .env file
echo "Generating BCrypt salt..."
if command -v poetry &> /dev/null
then
    SALT=$(poetry run python -c "import bcrypt; print(bcrypt.gensalt().decode())")
else
    SALT=$(python -c "import bcrypt; print(bcrypt.gensalt().decode())")
fi

echo "Your new BCrypt salt is: $SALT"


echo "Setup complete. Don't forget to fill in the required environment variables in the .env file."
