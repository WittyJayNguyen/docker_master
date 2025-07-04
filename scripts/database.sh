#!/bin/bash

# Database Management Script
echo "🗄️ Database Management for Docker Multi-Project..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage: ./scripts/database.sh [command] [options]${NC}"
    echo ""
    echo "Commands:"
    echo "  status              - Show database status"
    echo "  mysql               - Connect to MySQL"
    echo "  postgres            - Connect to PostgreSQL"
    echo "  mysql-dump [db]     - Dump MySQL database"
    echo "  postgres-dump [db]  - Dump PostgreSQL database"
    echo "  mysql-restore [db] [file] - Restore MySQL database"
    echo "  postgres-restore [db] [file] - Restore PostgreSQL database"
    echo ""
    echo "Examples:"
    echo "  ./scripts/database.sh status"
    echo "  ./scripts/database.sh mysql"
    echo "  ./scripts/database.sh postgres"
    echo "  ./scripts/database.sh mysql-dump laravel_db"
    echo "  ./scripts/database.sh postgres-dump laravel_db"
}

# Function to show database status
show_status() {
    echo -e "${GREEN}📊 Database Status:${NC}"
    echo ""
    
    # MySQL Status
    echo -e "${BLUE}MySQL:${NC}"
    if docker-compose exec -T mysql mysqladmin ping -h localhost --silent 2>/dev/null; then
        echo -e "  Status: ${GREEN}✅ Running${NC}"
        echo "  Host: localhost:3306"
        echo "  Databases: wordpress_db, laravel_db, main_db"
    else
        echo -e "  Status: ${RED}❌ Not running${NC}"
    fi
    
    echo ""
    
    # PostgreSQL Status
    echo -e "${BLUE}PostgreSQL:${NC}"
    if docker-compose exec -T postgres pg_isready -h localhost 2>/dev/null; then
        echo -e "  Status: ${GREEN}✅ Running${NC}"
        echo "  Host: localhost:5432"
        echo "  Databases: wordpress_db, laravel_db, main_db"
    else
        echo -e "  Status: ${RED}❌ Not running${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Management Interfaces:${NC}"
    echo "  phpMyAdmin (MySQL): http://localhost:8080"
    echo "  pgAdmin (PostgreSQL): http://localhost:8081"
}

# Function to connect to MySQL
connect_mysql() {
    echo -e "${GREEN}🔗 Connecting to MySQL...${NC}"
    docker-compose exec mysql mysql -u root -p
}

# Function to connect to PostgreSQL
connect_postgres() {
    echo -e "${GREEN}🔗 Connecting to PostgreSQL...${NC}"
    docker-compose exec postgres psql -U postgres
}

# Function to dump MySQL database
dump_mysql() {
    local db_name=$1
    if [ -z "$db_name" ]; then
        echo -e "${RED}❌ Please specify database name${NC}"
        exit 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="mysql_${db_name}_${timestamp}.sql"
    
    echo -e "${GREEN}📤 Dumping MySQL database: $db_name${NC}"
    docker-compose exec mysql mysqldump -u root -prootpassword123 $db_name > "backups/$filename"
    echo -e "${GREEN}✅ Database dumped to: backups/$filename${NC}"
}

# Function to dump PostgreSQL database
dump_postgres() {
    local db_name=$1
    if [ -z "$db_name" ]; then
        echo -e "${RED}❌ Please specify database name${NC}"
        exit 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="postgres_${db_name}_${timestamp}.sql"
    
    echo -e "${GREEN}📤 Dumping PostgreSQL database: $db_name${NC}"
    docker-compose exec postgres pg_dump -U postgres $db_name > "backups/$filename"
    echo -e "${GREEN}✅ Database dumped to: backups/$filename${NC}"
}

# Function to restore MySQL database
restore_mysql() {
    local db_name=$1
    local file_path=$2
    
    if [ -z "$db_name" ] || [ -z "$file_path" ]; then
        echo -e "${RED}❌ Please specify database name and file path${NC}"
        exit 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}❌ File not found: $file_path${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}📥 Restoring MySQL database: $db_name${NC}"
    docker-compose exec -T mysql mysql -u root -prootpassword123 $db_name < "$file_path"
    echo -e "${GREEN}✅ Database restored successfully${NC}"
}

# Function to restore PostgreSQL database
restore_postgres() {
    local db_name=$1
    local file_path=$2
    
    if [ -z "$db_name" ] || [ -z "$file_path" ]; then
        echo -e "${RED}❌ Please specify database name and file path${NC}"
        exit 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}❌ File not found: $file_path${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}📥 Restoring PostgreSQL database: $db_name${NC}"
    docker-compose exec -T postgres psql -U postgres $db_name < "$file_path"
    echo -e "${GREEN}✅ Database restored successfully${NC}"
}

# Create backups directory if it doesn't exist
mkdir -p backups

# Parse command
case $1 in
    status)
        show_status
        ;;
    mysql)
        connect_mysql
        ;;
    postgres)
        connect_postgres
        ;;
    mysql-dump)
        dump_mysql $2
        ;;
    postgres-dump)
        dump_postgres $2
        ;;
    mysql-restore)
        restore_mysql $2 $3
        ;;
    postgres-restore)
        restore_postgres $2 $3
        ;;
    -h|--help|"")
        show_usage
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        show_usage
        exit 1
        ;;
esac
