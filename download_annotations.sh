#!/bin/bash
# =============================================================================
# Objects365 Download Tools - Annotations Downloader
# Copyright (c) 2026 ITLAN
# =============================================================================

ANNOTATION_DIR="object365/annotations"
LOG_FILE="download_annotations.log"
mkdir -p "$ANNOTATION_DIR"

# ПРАВИЛЬНЫЕ ссылки из кода YOLOv5
ANNOTATIONS=(
    "https://dorc.ks3-cn-beijing.ksyun.com/data-set/2020Objects365%E6%95%B0%E6%8D%AE%E9%9B%86/train/zhiyuan_objv2_train.tar.gz"
    "https://dorc.ks3-cn-beijing.ksyun.com/data-set/2020Objects365%E6%95%B0%E6%8D%AE%E9%9B%86/val/zhiyuan_objv2_val.json"
)

echo "========================================="
echo "📥 Скачивание аннотаций Objects365"
echo "========================================="
echo "Директория: $ANNOTATION_DIR"
echo "========================================="

for url in "${ANNOTATIONS[@]}"; do
    filename=$(basename "$url")
    output="$ANNOTATION_DIR/$filename"
    
    echo ""
    echo "📦 Скачивание: $filename"
    
    # Используем curl
    curl -# -L --retry 9 -C - -o "$output" "$url"
    
    if [ $? -eq 0 ] && [ -f "$output" ]; then
        size=$(du -h "$output" | cut -f1)
        echo "✅ Успешно: $filename ($size)"
        
        # Если это tar.gz архив, распакуем его
        if [[ "$filename" == *.tar.gz ]]; then
            echo "📦 Распаковка $filename..."
            tar -xzf "$output" -C "$ANNOTATION_DIR"
            if [ $? -eq 0 ]; then
                echo "✅ Распаковано в $ANNOTATION_DIR"
                # Покажем, что внутри
                ls -lh "$ANNOTATION_DIR" | grep -v "$filename"
            fi
        fi
    else
        echo "❌ Ошибка загрузки $filename"
    fi
    
    sleep 2
done

echo ""
echo "========================================="
echo "📊 Содержимое $ANNOTATION_DIR:"
ls -lh "$ANNOTATION_DIR"
echo "========================================="
