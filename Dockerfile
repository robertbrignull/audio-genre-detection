# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    git \
    cmake \
    build-essential \
    libyaml-cpp-dev \
    libfftw3-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libsamplerate0-dev \
    libtag1-dev \
    libchromaprint-dev \
    curl


# Install the required Python packages
RUN pip3 install essentia-tensorflow
RUN pip3 install fastapi uvicorn requests python-multipart
RUN pip install numpy==1.26.4

# Create a working directory
WORKDIR /app

# Clone the GitHub repository (uncomment if necessary)
RUN git clone https://github.com/cobanov/audio-genre-detection.git .

# Make sure that the 'download.sh' script is executable and run it
RUN chmod +x download.sh
RUN ./download.sh

# Expose the port that the application will run on
EXPOSE 8000

# Define the command to run your FastAPI application
CMD ["uvicorn", "predict_api:app", "--host", "0.0.0.0", "--port", "8000"]
