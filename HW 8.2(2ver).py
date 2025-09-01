prices = [1000, 3499, 250]
nds = 0.20
print("Цена без НДС:ыы",prices)
def add_vat(prices, nds):
    finale_price = []
    for i in prices:
        finale_price.append(i + i * nds)
    return finale_price

print("Итоговая цена с НДС",add_vat(prices, nds))

