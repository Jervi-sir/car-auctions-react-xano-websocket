*This is a submission for the [Xano AI-Powered Backend Challenge](https://dev.to/challenges/xano-2025-11-20): Full-Stack, AI-First Application*

---
description: "Xano AI Challenge submission — Real-Time Car Auction App with WebSockets, Tasks, and AI-driven backend logic."
---

---

*This is a submission for the [Xano AI-Powered Backend Challenge](https://dev.to/challenges/xano-2025-11-20): Full-Stack, AI-First Application*

---

## What I Built

<!-- Provide an overview of your full-stack application and what problem it solves. -->

**CarBid Live** is a real-time car auction platform for classic and luxury vehicles, built with an **AI-first backend on Xano** and a **React + TypeScript** frontend.

It solves three main problems of traditional auctions:

* 🌍 **Accessibility** – anyone can join from anywhere.
* ⚡ **Real-time transparency** – WebSocket-powered live bidding, no manual refresh or polling.
* 🤖 **Automation** – scheduled background tasks finalize auctions, compute winners, and handle reserve prices.

## Demo

<!-- Share a link to your deployed application and include screenshots or videos showing your solution in action. If login is required, provide test credentials. -->

### Live App

* **URL**: *Deployment in progress* (frontend + Xano backend ready; hosting wiring ongoing)
- frontend from Xano: https://default-dev-ef16ae-xqrx-tgqf-f4ju.n7e.xano.io/
- frontend from Vercel (as backup): https://car-auctions-xano.vercel.app/login

### Test Credentials

```txt
Email: xano@mail.com
Password: password
```

### Dev Tools used

- IDE: Antigravity: a forked Vs-code IDE made by google, and it provides AI Agents
- Ai used: 
  * for React front end: Gemini 3 pro, in order to get a non over engeneered projects, 
  * for database schema: Gemini 3 pro
  * for backend logic (Xanoscript): Claude Sonnet 4.5
  * I have created this GPT [Xano|Xanoscript Gpt](https://chatgpt.com/g/g-693365cca9f48191b8709c12b4f53a05-xano-xanoscript)


### Core Features

**For bidders**

* Live bidding with instant WebSocket updates
* Bid history & win tracking
* Outbid awareness via live updates

**For sellers**

* Create, edit, and delete auctions
* Detailed car specs, images, condition reports
* Reserve price support
* Stats: views, bids, watchers per auction

**Platform**

* JWT-based auth with Xano’s auth system
* Background tasks for auction finalization & trending score updates
* Indexed tables for performant queries
* Responsive React UI (React 19, TS, Tailwind v4, Radix UI)

---


### What You Can See in the UI

* **Auction Listing Page**

  * Paginated list of active auctions
  * Current price, bid count, time remaining
  * Filters (status, price range, location)

* **Auction Detail Page**

  * Live countdown until auction end
  * Real-time bid feed (via `@xano/js-sdk` WebSockets)
  * Full specs: engine, power, color, VIN, owners
  * Image
  * Place bid with validation and error feedback

* **My Posted Auctions**

  * All auctions created by the logged-in user
  * Edit/delete actions
  * Basic stats: total views, bids, watchers

* **User Profile**

  * Update profile fields
  * View your bids / wins overview
  * Delete account (handled via Xano auth APIs)

---

## The AI Prompt I Used

<!-- Share the original AI prompt(s) you used to generate your backend. -->

I have build the front-end first with Gemini 3 pro, in order to get a non over engeneered projects, made sure it uses types, so I can just use these type as a schema for Xano.

as for backend, I used several prompts to steer AI into generating **XanoScript-friendly** backend logic and database structure. Here are the main ones (lightly trimmed for clarity):

| keep in mind after each ai generation, i have to push the change to Xano, in order to validate the ganerated code

### 1️⃣ Database Schema Generation

```txt
I want to build a car auction platform. Generate Xano database tables
following this TypeScript structure:

type Bid = { id: number; bidderName: string; amount: number; time: string; }

type AuctionCar = {
  id: string;
  title: string;
  subtitle: string;
  imageUrl: string;
  year: number;
  mileageKm: number;
  fuel: string;
  transmission: string;
  location: string;
  startingPrice: number;
  currentPrice: number;
  currency: string;
  endsInMinutes: number;
  specs: {
    engine: string;
    powerHp: number;
    color: string;
    vin: string;
    owners: number;
  };
  initialBids: Bid[];
};

Requirements:
- Create user table for authentication
- Prefix tables with numbers (143_, 144_, etc.)
- Add proper indexes
- Include view history tables
```

### 2️⃣ API Endpoints (Car Domain)

```txt
Create RESTful API endpoints for the car auction platform, grouped under "car":

1. List auctions (GET /auctions/list) with pagination and filters
2. Get auction by slug (GET /auctions/slug) and track views
3. Get bid history (GET /auctions/bids)
4. Place bid (POST /bids/place) - authenticated and validated
5. Create/Edit/Delete "my auctions" endpoints
6. Get auction stats

Use:
- Proper HTTP status codes
- Validation
- Ownership checks
- Efficient queries with joins
```

### 3️⃣ Authentication System

```txt
Create a complete user authentication system in Xano:
- Signup (email/password validation)
- Login (returns JWT)
- Me endpoint (current user)
- Update profile
- Delete account
- Enforce email uniqueness
- Hash passwords with bcrypt
```

### 4️⃣ Background Task: Auction Finalization

```txt
Create a background task that runs every 60 minutes and:

- Finds car_auction rows where auction_end < now
- Only process active, not-yet-finalized auctions
- Gets highest valid bid from car_bid
- If reserve price set, check if highest bid meets it
- Update status:
  - Sold + winning_bidder_id if reserve met
  - Ended (not sold) if reserve not met
  - Ended (no bids) if no bids
- Log processing stats
```

### 5️⃣ WebSocket Integration

```txt
Set up WebSockets for real-time auction updates:

- Channel name: auctionSession
- Support auctionSession:{car_auction_id} dynamic channels
- Allow public viewers
- Add trigger on car_bid.after_insert
- Emit events with bidder info, amount, timestamp
- Frontend should subscribe and update UI on "new_bid"
```

---

## How I Refined the AI-Generated Code

<!-- Describe how you transformed the AI-generated backend in Xano. What did you refactor to make it more scalable, secure, or maintainable? Include before/after code snippets to showcase your improvements (if applicable). -->

AI gave me **80% of the structure**, but XanoScript is strict and opinionated. The remaining **20%** was about turning “almost-right” into “production-ready”.

### 1️⃣ Fixing XanoScript Syntax

AI often generated invalid queries: inline comments, unquoted names, multi-line conditions.

**AI version (invalid):**

```xanoscript
query 1_list_auctions_GET verb=GET {  // Get all auctions
  stack {
    text bid_source?="web" // web, mobile, api
  }
}
```

**Refined version (valid & safer):**

```xanoscript
query "109_auctions_list_GET" verb=GET {
  stack {
    text bid_source?="web"
  }
}
```

**Main adjustments:**

* Always quote query names
* Remove inline comments from blocks
* Keep comments above or outside the block

---

### 2️⃣ Handling Conditionals (No `else if`)

AI tried to do standard `else if` chains, which XanoScript doesn’t support.

**AI version:**

```xanoscript
conditional {
  if ($condition1) { ... }
  else if ($condition2) { ... } // invalid
}
```

**Refined version:**

```xanoscript
conditional {
  if ($condition1) {
    // ...
  }
  else {
    conditional {
      if ($condition2) {
        // ...
      }
    }
  }
}
```
or 

```xanoscript
conditional {
  if ($condition1) {
    // ...
  }
  elseif ($condition2) {
      // ...
    }
}
```

---

### 3️⃣ Single-Line WHERE Clauses

XanoScript doesn’t allow multi-line `where` expressions.

**AI version:**

```xanoscript
db.query car_auction {
  where = $db.car_auction.is_active == true
    && $db.car_auction.is_sold == false
    && $db.car_auction.auction_end < $now
}
```

**Refined:**

```xanoscript
db.query car_auction {
  where = $db.car_auction.is_active == true && $db.car_auction.is_sold == false && $db.car_auction.auction_end < $now
}
```

The logic stayed the same, but syntax had to be compact.

---

### 4️⃣ Arrays & Markdown Artifacts

Sometimes the AI leaked Markdown into XanoScript:

**AI version:**

````xanoscript
features: ```
  [
    "Twin Turbo"
    "Carbon Fiber Body"
  ]
````

````

**Refined:**
```xanoscript
features: [
  "Twin Turbo",
  "Carbon Fiber Body",
  "Racing Seats"
]
````

---

### 5️⃣ WebSocket Implementation

The biggest gap: **dynamic WebSocket channels**.

AI didn’t fully infer the pattern from docs, so I:

1. Watched Xano’s realtime tutorial [Realtime Xano](https://youtu.be/sfCoy_X_FSg?si=AK72XYCJO2gAA9ZZ&t=198)
2. Checked SDK docs for `@xano/js-sdk`  [Xano docs](https://docs.xano.com/realtime/realtime-in-xano)
3. Implemented the base client manually, then let AI help expand usage.

**Core client:**

```ts
// xano/websocket.ts
import { XanoClient } from "@xano/js-sdk";

const instanceBaseUrl = "";
const realtimeConnectionHash = "";

export const xanoClient = new XanoClient({
  instanceBaseUrl,
  realtimeConnectionHash,
});

export const getXanoChannel = (channelName: string) =>
  xanoClient.channel(channelName);
```

**Subscription in React:**

```ts
// anyware we can to implement the Websocket, must be specifically inside the auction session, not global

useEffect(() => {
  if (!car) return;
  const channelName = `auctionSession/${car.id}`;
  const channel = xanoClient.channel(channelName);

  const handler = (msg: any) => {
    if (msg.action !== "event" && msg.action !== "message") return;
    const data = msg?.payload?.data;
    if (!data || data.action !== "new_bid") return;

    const newBid = {
      id: data.payload.id,
      bidderName: data.payload.bidder_name || `User ${data.payload.bidder_id}`,
      amount: data.payload.amount,
      time: new Date().toISOString(),
    };

    setBids(prev =>
      prev.some(b => b.id === newBid.id) ? prev : [...prev, newBid]
    );

    setCar(prev => prev && newBid.amount > prev.currentPrice
      ? { ...prev, currentPrice: newBid.amount }
      : prev
    );
  };

  channel.on(handler);

  return () => {
    channel.destroy();
  };
}, [car?.id]);
```

This turned auctions into truly **live sessions** without polling.

---

### 6️⃣ Auction Finalization Task

The AI’s first draft was naive: it just ended everything past `auction_end` without checking reserve prices or states.

I refined it to:

* Only process active, not-yet-finalized auctions
* Get the highest valid bid
* Compare to reserve (if set)
* Mark as:
  * **sold** + `winning_bidder_id` set
* This logic runs in a front end of a user to help out with the auction finalization
or if no users are in the auction session page (which is rare) we do:
* Run every 30 minutes via Xano task scheduler

---

## My Experience with Xano

<!-- Share your overall experience using Xano. What did you find most helpful? Were there any challenges? -->

### 🌟 What I Loved

* **Database-first design**
  Defining tables, filters, and indexes directly in XanoScript feels natural. It forces good modeling from day one.

* **Built-in Auth**
  Having auth, JWT, and `auth.user` context available in queries simplified everything from “my auctions” to secure bid placement.
  Also being able to quickly assign which table can be authenticable

* **WebSockets & Tasks Built-In**
  No extra infrastructure. Real-time auctions + scheduled finalization tasks all live inside Xano.

* **API Organization**
  Grouping endpoints under `/car` and `/user` kept things tidy and scalable.

---

### 😅 Challenges

* **XanoScript learning curve**
  Coming from Laravel/Go, the strict syntax rules (comments, arrays, conditionals) took getting used to, that's why I notice Ai do hallucinate syntax, since its been only trained on most popular coding languages

* **AI hallucinating syntax**
  AI often produced *almost valid* XanoScript with tiny issues that break everything: inline comments, missing quotes, multiline where, Markdown artifacts.

* **IDE & extension quirks**
  The VS Code/Antigravity extension is helpful, but syntax errors sometimes caused weird push behavior, sometime it doesn't consider comments as an issue, but then when pushing to Xano, it breaks only because we used comments

**My workaround:**
I ended up using this loop:

1. Let AI generate code
2. Paste into Xano web UI
3. Fix errors until valid
4. Copy back into the repo as the “source of truth”
5. Reuse that validated pattern to guide future AI generations

| Also I have noticed that the more valid XanoScript existed in the codebase, the better AI became at staying within the syntax.

---

### 🔚 Overall Takeaway

* **Xano** made it realistic for a solo dev to ship a real-time auction backend: DB, auth, real-time, tasks, all in one place.
* **AI** dramatically accelerated boilerplate and structure.
* **Human judgment** was essential for correctness, performance, and security.

The result: **CarBid Live** — a concrete example that with Xano + AI, **one developer can build what used to need a whole team.**

---

## 🔧 Adding New Features After the Core Build

Once the core real-time auction functionality was complete (bidding, live updates, auction finalization), I extended the platform by adding **user-driven auction management**:

* Create auctions
* Edit auctions
* Delete auctions
* Update user profile
* Delete user account

Because the project already had a stable codebase with validated XanoScript patterns, adding these new features was **straightforward**. AI performed well here because:

1. It could reuse existing query structures
2. It already understood the API routes and schema
3. The logic was simpler than real-time bidding or background tasks

### The One Unexpected Issue

To support user-owned auctions, I needed to add a new column to the `car_auction` table:

```xanoscript
table car_auction {
  auth = false

  schema {
    ...
    int? created_by? {
      table = "user"
    }
    ...
  }
  ...
}
```

AI correctly generated the update, but when pushing the file to Xano, the system returned an error:

> **“Table already exists”**

This happened because XanoScript interpreted the updated file as a *new table definition* rather than a *table modification*.

Since I only wanted to **add a column**, not recreate the table, I handled this manually:

* Opened the table in the Xano UI
* Added the `created_by` field directly
* Synced the codebase afterward to prevent overwriting

After this manual correction, the new features worked seamlessly — AI-generated endpoints flowed normally, and the frontend integrations were smooth.

### Takeaway

* **XanoScript is great for initial schema creation**, but certain schema modifications (adding/removing fields) are safer when done manually in the UI.
* Once the correct patterns exist in the codebase, **AI becomes far more reliable** when expanding features.

---

## ⏱️ Time Consumed

This project was completed over **4 days of focused development**, with the majority of time spent on **testing, debugging, and integrating the Xano backend with the React frontend**. While AI accelerated initial development, real production refinement required extensive manual verification.

### **Breakdown by Phase**

| Phase                                           | Time Spent | AI Contribution | Manual Work | Notes                                                                                                           |
| ----------------------------------------------- | ---------- | --------------- | ----------- | --------------------------------------------------------------------------------------------------------------- |
| **Day 1 — Planning & Schema Setup**             | ~4 hours   | 60%             | 40%         | Designing auction logic, generating initial tables with AI, restructuring schema, adding indexes                |
| **Day 1 — API Endpoints (Draft)**               | ~6 hours   | 85%             | 15%         | AI generated CRUD endpoints, I refined query logic & validations                                                |
| **Day 2 — Background Tasks + WebSockets**       | ~5 hours   | 50%             | 50%         | AI helped draft tasks; dynamic websocket channels & auction finalization required manual logic                  |
| **Day 2 — Frontend Components**                 | ~3 hours   | 90%             | 10%         | React pages scaffolded quickly using AI (list, detail, bidding, dashboard)                                      |
| **Day 3 — Backend ↔ Frontend Integration**      | ~8 hours   | 70%             | 30%         | This was the most time-consuming early stage: resolving 404/400/500 errors, payload mismatches, schema fixes    |
| **Day 3–4 — Testing, Debugging & Validation**   | ~10 hours  | 0%              | 100%        | Ensuring: bidding flow works, auctions finalize correctly, reserve logic works, websocket updates fire reliably |
| **Day 4 — Refinement & UX Fixes**               | ~4 hours   | 40%             | 60%         | Polishing user flows, improving error messages, adjusting API responses                                         |
| **Day 4 — Documentation & Submission Write-up** | ~2 hours   | 70%             | 30%         | Cleaning prompts, summarizing learnings, writing this submission                                                |

### **Total Time Invested: ~42 hours (≈ 4 full days)**

---

### 🧠 What Took the Most Time?

Although AI generated a large portion of the backend structure, the **real work** came from:

* fixing syntax issues in XanoScript
* validating every route manually
* debugging incorrect AI-generated logic
* adjusting schema changes mid-development
* integrating the APIs into React
* handling websocket behavior, cleanup, and reconnections
* ensuring auctions finalize correctly across all edge cases
* testing bids, bids ordering, watchers, price updates
* refactoring payloads to match frontend expectations

This **testing + integration cycle** consumed almost **50% of the total development time**.

