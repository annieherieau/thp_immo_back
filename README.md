# Marketplace immo (back)
Marketplace d'immobilier où les personnes vont pouvoir faire de l'achat/vente de biens immobiliers.

**La team RAYM** : [Robena](https://github.com/Robe-Ras), [Annie](https://github.com/annieherieau), [Yann](https://github.com/YannRZG) et [Malo](https://github.com/Korblen)


## Stack

L'application est Full Stack avec :
- un backend avec une API en Rails
- un frontend avec React

## Installation en local (BACKEND)
- Ruby 3.3.0
- Rails 7.1.3.4

Clone repository

```bash
git clone [repo]
```

Install dépendencies

```bash
cd thp_immo_back_rails_api_boiler_plate
bundle install
```

Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

Launch server

```bash
rails server
```
