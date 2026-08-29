FROM python:3.12-slim
FROM ubuntu:22.04

WORKDIR /app

FROM ubuntu:22.04

WORKDIR /app

# 新增這兩行：更新套件清單並安裝 python3 與 python3-pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency list first for better Docker cache usage
COPY requirements.txt /tmp/requirements.txt

# Install Python packages
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy project files into container
COPY app ./app
COPY config ./config
COPY core ./core
COPY repository ./repository
COPY tests ./tests
COPY pytest.ini .
COPY api ./api
COPY .coveragerc .
COPY data ./data

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]         # DB version (default)

#CMD ["uvicorn", "api.fastapi_app:app", "--host", "0.0.0.0", "--port", "80"] # for user would like to run EXcel (option)
