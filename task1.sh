#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Команда используется в виде:  <входная_директория> <выходная_директория>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Ошибка: Входная директория не существует."
    exit 1
fi

if [ ! -d "$2" ]; then
    mkdir -p "$2"
fi

copy() {
    local source_dir="$1"
    local destination_dir="$2"
    local file
    for file in "$source_dir"/*; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            if [ -f "$destination_dir/$filename" ]; then
                local index=1
                local new_filename="${filename%.*}_$index.${filename##*.}"
                while [ -f "$destination_dir/$new_filename" ]; do
                    let index++
                    new_filename="${filename%.*}_$index.${filename##*.}"
                done
                cp "$file" "$destination_dir/$new_filename"
            else
                cp "$file" "$destination_dir"
            fi
        elif [ -d "$file" ]; then
            copy "$file" "$destination_dir"
        fi
    done
}

# Вызов функции для копирования файлов из входной директории в выходную
copy "$1" "$2"

echo "Копирование завершено."
