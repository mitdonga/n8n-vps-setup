# n8n VPS Setup Guide

This guide will walk you through setting up n8n (queue/worker mode) on your VPS using Docker Compose.

## Prerequisites

- A VPS instance with SSH access
- Git installed
- Basic familiarity with command line operations

## Setup Steps

### 1. Connect to Your VPS

```bash
ssh your-username@your-vps-ip
```

### 2. Install Docker and Docker Compose + DNS setup

Follow steps 1-3 from the [official n8n Docker Compose installation guide](https://docs.n8n.io/hosting/installation/server-setups/docker-compose/).

### 3. Create Application Directory

Create the n8n directory in your home folder:

```bash
mkdir -p ~/n8n
cd ~/n8n
```

### 4. Clone This Github Repo

Clone this repo inside your local n8n director

```bash
git clone https://github.com/mitdonga/n8n-vps-setup.git .
```

### 5. Set Up Environment Configuration

Copy the environment configuration file:

```bash
cp .env.example .env
```

**Note:** Make sure to edit the `.env` file with your specific configuration values.

### 6. Create Required Directories

#### Local Files Directory
Create a directory for local file storage at the root level:

```bash
sudo mkdir -p /local-files
sudo chown $USER:$USER /local-files
sudo chmod 755 /local-files
```

#### Redis Data Directory
Create a directory for Redis data persistence:

```bash
mkdir -p ~/n8n/redis-data
sudo chown -R $USER:$USER ~/n8n/redis-data
chmod 755 ~/n8n/redis-data
```

### 7. Initial n8n Launch

Start n8n for the first time to generate the encryption key:

```bash
docker compose up -d
```

### 8. Get Encryption Key

Retrieve the n8n encryption key from the main container:

```bash
cd ~/n8n
docker exec -it n8n-n8n-1 sh -c "cat .n8n/config"
```

Look for the `encryptionKey` value in the output.

### 9. Configure Encryption Key

Update your `.env` file with the encryption key:

```bash
# Edit .env file and set:
N8N_ENCRYPTION_KEY=your_encryption_key_here
```

### 10. Run n8n in Queue Mode

Spin multiple workers

```bash
docker compose up -d --scale n8n-worker=5
```

This will run n8n in queue mode with 5 worker instances for better performance.

### 11. Set Up Update Script

Make the update script executable:

```bash
chmod +x update-n8n.sh
```

## Verification

To verify your setup is working:

1. Check if containers are running:
   ```bash
   docker ps
   ```

2. Access n8n web interface at: `https://your-domain`

3. Check logs if needed:
   ```bash
   docker compose logs -f
   ```

## Maintenance

### Updating n8n

Use the provided update script:

```bash
cd n8n && ./update-n8n.sh
```

## Troubleshooting

- **Port conflicts**: Ensure ports 5678 and 5679 are available
- **Permission issues**: Check directory ownership and permissions
- **Container failures**: Review logs with `docker compose logs`
- **Database issues**: Verify Redis data directory permissions

## Support

For more detailed information, refer to the [official n8n documentation](https://docs.n8n.io/).

## File Structure

```
n8n-vps-setup/
├── docker-compose.yml
├── .env.example
├── update-n8n.sh
└── README.md
```



