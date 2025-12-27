# Wompi::Ruby

Una gema de Ruby de **alto nivel** diseñada para integrar la pasarela de pagos **Wompi Colombia** de forma sencilla. Esta gema abstrae la complejidad técnica de la API, encargándose automáticamente de la **firma de integridad**, el manejo de entornos y la tokenización.

## Características

* ✅ **Firma de Integridad Automática**: Generación de hash SHA-256 para transacciones seguras.
* ✅ **Multimedio de Pago**: Soporte completo para Tarjetas, PSE y Nequi.
* ✅ **Links de Pago**: Creación y gestión de URLs de cobro con parámetros de seguridad.
* ✅ **Gestión de Transacciones**: Consulta de estados individuales y listado histórico con paginación inteligente.
* ✅ **Seguridad**: Manejo diferenciado de llaves públicas y privadas según los requisitos de cada endpoint.

---

## Instalación

Instala la gema y añádela a tu Gemfile ejecutando:

```bash
gem 'wompi-ruby'
```

Configuración
Configura tus credenciales en un inicializador (ej. config/initializers/wompi.rb en Rails):

```ruby
Wompi.configure do |config|
  config.public_key  = 'pub_test_XXXXX'
  config.private_key = 'prv_test_XXXXX'
  config.environment = :sandbox # O :production
end
```

## Uso
1. Requisito Legal: Token de Aceptación
Wompi requiere que el usuario acepte términos y condiciones. Debes obtener este token antes de procesar cualquier transacción

```ruby
merchant = Wompi::Merchant.info
acceptance_token = merchant.dig('data', 'presigned_acceptance', 'acceptance_token')
```
2. Pagos con Tarjeta de Crédito
```ruby
# 1. Tokenizar la tarjeta (Requiere Llave Pública)
token_res = Wompi::Token.create_card(
  number: "4242424242424242",
  cvc: "789",
  exp_month: "12",
  exp_year: "30",
  card_holder: "juan perz"
)
card_token = token_res.dig('data', 'id')

# 2. Crear transacción (Maneja firma SHA-256 automáticamente)
transaction = Wompi::Transaction.create(
  amount_in_cents: 3000000, # $30.000 COP
  currency: "COP",
  reference: "REF_#{Time.now.to_i}",
  customer_email: "usuario@ejemplo.com",
  payment_method: {
    type: "CARD",
    token: card_token,
    installments: 1
  },
  acceptance_token: acceptance_token,
)
```

3. Pagos con PSE (Transferencia Bancaria)
```ruby
# 1. Listar bancos disponibles
banks = Wompi::Pse.financial_institutions

# 2. Crear transacción
res = Wompi::Transaction.create(
  amount_in_cents: 5000000,
  currency: "COP",
  reference: "PSE_#{Time.now.to_i}",
  customer_email: "cliente@correo.com",
  payment_method: {
    type: "PSE",
    financial_institution_code: "1022", # Código del banco obtenido del listado
    user_type: 0, # 0: Persona, 1: Empresa
    user_legal_id_type: "CC",
    user_legal_id: "12345678",
    payment_description: "Pago de suscripción"
  },
  redirect_url: "https://tu-tienda.com/pago/resultado",
  acceptance_token: acceptance_token,
)

# El usuario debe ser redirigido a la URL del banco:
url_pago = res.dig('data', 'payment_method', 'extra', 'async_payment_url')
```

4. Pagos con Nequi
```ruby
# 1. Tokenizar número celular (Llave Pública)
nequi_token = Wompi::Token.create_nequi("3004444444").dig('data', 'id')

# 2. Crear transacción
res = Wompi::Transaction.create(
  amount_in_cents: 2500000,
  currency: "COP",
  reference: "NEQUI_#{Time.now.to_i}",
  customer_email: "usuario@ejemplo.com",
  payment_method: {
    type: "NEQUI",
    token: nequi_token,
    phone_number: "3004444444"
  },
  acceptance_token: acceptance_token,
)
# El usuario recibirá una notificación PUSH en su app Nequi para aprobar el pago.
```

5. Links de Pago
Genera una URL compartible para tus clientes sin necesidad de un checkout propio:
```ruby
link = Wompi::PaymentLink.create(
  name: "Producto Digital",
  amount_in_cents: 5000000,
  currency: "COP",
  single_use: true,
  collect_shipping: false,
  reference: "LNK_#{Time.now.to_i}",
)
puts "URL de Cobro: [https://checkout.wompi.co/l/#](https://checkout.wompi.co/l/#){link.dig('data', 'id')}"
```

6. Historial de Transacciones
La gema maneja la paginación y filtros obligatorios automáticamente:
```ruby
# Obtener transacciones de los últimos 30 días (Valores por defecto)
history = Wompi::Transaction.all

# Búsqueda con filtros y rango extendido
history = Wompi::Transaction.all(
  from_date: "2025-01-01T00:00:00",
  until_date: "2025-12-31T23:59:59",
  page_size: 50
)
```

Manejo de Errores
La gema utiliza excepciones específicas para ayudarte a identificar problemas rápidamente:
```ruby
begin
  # Operación de Wompi
rescue Wompi::InvalidRequestError => e
  # Error 422: Parámetros inválidos o error de validación de la API
  puts "Errores detectados: #{e.messages}"
rescue Wompi::NotFoundError => e
  # Error 404: No se encontró el recurso (ID inexistente)
  puts "No encontrado: #{e.message}"
rescue Wompi::ApiError => e
  # Otros errores de la API (500, 401, etc.)
  puts "Error del servidor: #{e.message}"
end
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wjorellano/wompi-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
