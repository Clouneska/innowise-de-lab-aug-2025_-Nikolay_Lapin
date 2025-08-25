from operator import truediv

name = input("Как тебя зовут?")
print("Привет,", name,"!","Приятно познакомиться")

length = int(input("Введите длину прямоугольника:"))
width = int(input("Введите ширину прямоугольника:"))
area = length * width
print("Площадь прямоугольника:",area)

temperatureC = float(input("Введите температуру в градусах Цельсия:"))
temperatureF = temperatureC * 9 / 5 + 32
print("это",temperatureF,"°F")

import random
random_number = random.randint(1,5)
while True:
    number = int(input("Я загадал число от 1 до 5. Попробуй угадать!"))
    if number == random_number:
        print("Ты угадал!")
        break
    elif number > random_number:
        print("Слишком много!")
    else:
        print("Слишком мало!")

numeric = int(input("Введите число:"))
while True:
    if numeric % 2 == 0:
        print("Число",numeric,"-четное")
        break;
    else:
        print("Число", numeric,"-нечетное")
        break;
