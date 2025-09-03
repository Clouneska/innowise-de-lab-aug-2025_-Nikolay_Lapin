email = " USER@DOMAIN.COM "
cleaned_email = email.strip()
normalized_email = cleaned_email.lower()
email_id = normalized_email.lower().replace(" ", "")

print(f"Исходные данные: '{email}' ")
print(f"Нормализованные:'{normalized_email}' ")
print(f"ID длясистемы:'{email_id}' ")

username, domain = normalized_email.split("@")
print(f"Имя пользователя: {username}")
print(f"Домен: {domain}")