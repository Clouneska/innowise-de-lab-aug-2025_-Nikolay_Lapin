shopping_list = ["milk", "bread", "eggs", "butter", "apples"] #заполняем наш список нужными к покупке товаров
print("Список покупок:")
#Используется цикл перебора каждого элемента shopping_list, а также добавление нумерации каждой позиции
for i, name in enumerate(shopping_list, start=1):
    print(f"{i}. Покупаю: {name}")
#Вводим понятия старта откуда нам начинать отсчет
start = int(input("Введите  число для обратного отсчета:"))
for i in range(start, 0 , -1): #Цикл который задает направление для наших значений
    print(f"{i}...") #Вывод значений i
#Финальный Go!
print("Go!")

import random
random_number = random.randint(1,10)
#используем цикл While, чтобы мы искали число до момента пока не угадаем
while True:
    number = int(input("Я загадал число от 1 до 10. Попробуй угадать!"))
    if number == random_number:
        print("Поздравляю! Вы угадали число!")
        break
    else:
        print("Неверно, попробуй еще раз.")

scores = [75, 88, -10, 95, 100, -25, 89]
total_score = 0

for score in scores:
    if score < 0:
        continue #Убираем все отрицательные значения для подсчета и продолжаем выполнение программы
    total_score += score #Добавляем к общему баллу балл(не отрицательный)
    print(f"Добавлен балл:{score}")
else:
    print("Все данные успешно обоработаны.")

print(f"\nИтоговая сумма баллов: {total_score}")

num = [75, 88, 95, 0, 100]
total_num = 0
for numb in num:
    if numb == 0: # Цикл сравнения значения с нулем
        print("Обработка прервана")
        break #Прерывание цикла при score == 0
    total_num += numb
    print(f"Добавлен балл: {numb}")

print(f"\nИтоговая сумма баллов: {total_num}")

row = int(input("Введите высоту прямоугольника:"))
column = int(input("Введите ширину прямоугольника:"))
for i in range(row): #задаем построение прямоугольника по высоте
    for j in range(column): #задаем построение прямоугольника по ширине
        print(f"*", end=" ")#Выводим на экране построенный прямоугольник
    print()#пустая строка для отступа, когда заполняется ширина