#!/bin/bash

# Script tạo platform mới từ template
# Usage: ./create-platform.sh laravel my-shop 8008

PLATFORM_TYPE=$1
PROJECT_NAME=$2
PORT=$3

if [ -z "$PLATFORM_TYPE" ] || [ -z "$PROJECT_NAME" ] || [ -z "$PORT" ]; then
    echo "Usage: $0 <platform_type> <project_name> <port>"
    echo "Example: $0 laravel my-shop 8008"
    echo "Available types: laravel, wordpress, vue"
    exit 1
fi

PLATFORM_DIR="platforms/${PROJECT_NAME}"
TEMPLATE_DIR="platforms/templates"

# Tạo thư mục platform
mkdir -p "$PLATFORM_DIR"

# Copy template dựa trên loại platform
case $PLATFORM_TYPE in
    "laravel")
        TEMPLATE_FILE="$TEMPLATE_DIR/laravel.template.yml"
        ;;
    "wordpress")
        TEMPLATE_FILE="$TEMPLATE_DIR/wordpress.template.yml"
        ;;
    "vue")
        TEMPLATE_FILE="$TEMPLATE_DIR/vue.template.yml"
        ;;
    *)
        echo "Unknown platform type: $PLATFORM_TYPE"
        exit 1
        ;;
esac

# Tạo docker-compose file từ template
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{PORT}}/$PORT/g" \
    -e "s/{{PLATFORM_TYPE}}/$PLATFORM_TYPE/g" \
    "$TEMPLATE_FILE" > "$PLATFORM_DIR/docker-compose.$PROJECT_NAME.yml"

# Tạo .env file
cat > "$PLATFORM_DIR/.env" << EOF
PROJECT_NAME=$PROJECT_NAME
PROJECT_PORT=$PORT
PLATFORM_TYPE=$PLATFORM_TYPE
APP_PATH=../../projects/$PROJECT_NAME
LOG_PATH=../../logs/apache/$PROJECT_NAME
EOF

# Tạo thư mục project
mkdir -p "projects/$PROJECT_NAME"
mkdir -p "logs/apache/$PROJECT_NAME"

# Tự động thêm platform vào main docker-compose.yml
MAIN_COMPOSE="docker-compose.yml"
PLATFORM_INCLUDE="  - ./platforms/$PROJECT_NAME/docker-compose.$PROJECT_NAME.yml"

if [ -f "$MAIN_COMPOSE" ]; then
    # Kiểm tra xem platform đã được thêm chưa
    if ! grep -q "./platforms/$PROJECT_NAME/docker-compose.$PROJECT_NAME.yml" "$MAIN_COMPOSE"; then
        # Thêm platform vào cuối phần include
        if grep -q "include:" "$MAIN_COMPOSE"; then
            # Thêm vào cuối phần include
            sed -i '' "/include:/a\\
$PLATFORM_INCLUDE" "$MAIN_COMPOSE"
        else
            # Tạo phần include mới
            echo "include:" >> "$MAIN_COMPOSE"
            echo "$PLATFORM_INCLUDE" >> "$MAIN_COMPOSE"
        fi
        echo "✅ Auto-added platform to docker-compose.yml"
    else
        echo "ℹ️  Platform already exists in docker-compose.yml"
    fi
fi

echo ""
echo "✅ Platform '$PROJECT_NAME' created successfully!"
echo "📁 Location: $PLATFORM_DIR"
echo "🌐 Port: $PORT"
echo "🔄 Auto-discovery: Enabled"
echo ""
echo "Next steps:"
echo "1. Add your $PLATFORM_TYPE code to projects/$PROJECT_NAME/"
echo "2. Start platform: ./platform-manager.sh start $PROJECT_NAME"
echo ""
echo "🎉 Platform will be automatically discovered by platform-manager.sh!"
