#!/bin/bash

# Demo script để show tính năng Auto-Discovery
echo "🎬 Demo: Auto-Discovery Platform System"
echo "========================================"
echo ""

echo "📋 1. Xem platforms hiện tại:"
./platform-manager.sh list
echo ""

echo "🆕 2. Tạo platform mới bằng script:"
echo "   Command: ./create-platform.sh laravel demo-project 8013"
./create-platform.sh laravel demo-project 8013
echo ""

echo "📋 3. Xem platforms sau khi tạo (auto-discovered):"
./platform-manager.sh list
echo ""

echo "🔧 4. Tạo platform thủ công:"
echo "   mkdir platforms/manual-demo"
mkdir -p platforms/manual-demo

echo "   Copy template..."
cp platforms/templates/laravel.template.yml platforms/manual-demo/docker-compose.manual-demo.yml

# Thay thế placeholders
sed -i '' 's/{{PROJECT_NAME}}/manual-demo/g' platforms/manual-demo/docker-compose.manual-demo.yml
sed -i '' 's/{{PORT}}/8014/g' platforms/manual-demo/docker-compose.manual-demo.yml

echo "   ✅ Manual platform created!"
echo ""

echo "📋 5. Xem platforms sau khi tạo thủ công (auto-discovered):"
./platform-manager.sh list
echo ""

echo "🧹 6. Cleanup demo platforms:"
echo "   Removing demo platforms..."
rm -rf platforms/demo-project
rm -rf platforms/manual-demo
rm -rf projects/demo-project
rm -rf projects/manual-demo

echo "   ✅ Cleanup completed!"
echo ""

echo "📋 7. Final platform list:"
./platform-manager.sh list
echo ""

echo "🎉 Demo completed!"
echo ""
echo "💡 Key takeaways:"
echo "   ✅ Platforms are auto-discovered from platforms/ directory"
echo "   ✅ No need to manually edit arrays or config files"
echo "   ✅ Just create folder + docker-compose file = Ready to use!"
echo "   ✅ Works with both script generation and manual creation"
