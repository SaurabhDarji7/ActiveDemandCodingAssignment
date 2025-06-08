# ActiveDemand Coding Assessment

Created by **Saurabh Darji**  

---

## Services

- **ApplicationStateBuilder** – Cleans the database and sets up the initial card deck.
- **BuildDeckService** – Builds the deck of cards (52 standard cards + 1 joker).
- **HandleOverdueCardsService** – Marks overdue cards as lost! and bans! the associated client.
- **ReturnCardService** – Handles card returns and charges rent.
- **RestockCardService** – Restocks lost cards (makes them available again) and charges a replacement fee.

---

## Routes

### Public

- `GET /api/card` – Returns a random card from the deck.
- `PUT /api/card` – Returns a card to the deck (from the client).

### Admin

- `PUT /api/admin/stock` – Returns the count of available, rented, and lost cards.
- `POST /api/admin/finances` – Returns all transactions recorded in the system.

---

## Models

### Client
- `id`
- `ip_address` – used to identify the client
- `status` – `active` or `banned`

### Card
- `id`
- `suit`
- `value`
- `status` – `available`, `rented`, or `lost`
- `client_id` – client who rented the card

### Transaction
- `id`
- `card_id`
- `type` – `rent` or `restock`
- `amount` – rent or restock fee charged
