words = ["hello", "world", "python", "code"]
#1. Список длин слов
lengths = [len(word) for word in words]
print("Длинны слов:",lengths)
#2. Слоава длинее 4 символов
long_words = [word for word in words if len(word) > 4]
print("Слова длинее 4 символов:",long_words)
#3. ССловарь {слово:длина}
word_lengths = {word: len(word) for word in long_words}
print(f"Словарь слов и их длин:",word_lengths)