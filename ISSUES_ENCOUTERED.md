design a production - ready public API around food, recipe, allergies system, a backend that will let developers be able to fetch the database, and filter them 
follwing the Xanoscript knowkledge, lets create the database tables before doing anything, and please prefix these tables with number like 1_ 2_...to respect the relationships, also add history log for recipe, so later we can add a background task that will update the receipe column named viewed score, so later we can make an api that will list trending recipe
again focus on database tables only

make function for each table in order to seed the tables, please prefix these function with numbers 1_ ...

good now for the seed_all_functions it inside it, to call an other function it supposed to be like this
function.run seed_cuisines as $func1

good, now i need 60 recipe.and more food and other tables

create all necessary apis so we can let the user interact, also please see the example /apis/user/* how its been done regarding the grouping, do follow the structure and also check the docs .md files 

good now for background tasks so every 24hours it checks view history, and it fille in the recipe the viewed_score 

now generate me a md files as documention for the api, showcasing everything, good well documented

----------------
 /// notes
- ai is adding a comment inside input{ // } and xano is crashing because of it 

- when i do this 
  where = $db.ingredient.category ==? $input.category 
  && $db.ingredient.name includes $input.search 
  && $db.ingredient.is_vegetarian ==? $input.is_vegetarian 
  && $db.ingredient.is_vegan ==? $input.is_vegan
  its not valid, 
  i have to make them inline


----------------
----------------
so far this project is about food recipe..
now i want to add a total different field which is abput car bidding 
follwoing this structure 
```
export type Bid = {
  id: number;
  bidderName: string;
  bidderAvatar?: string;
  amount: number;
  time: string; // human readable
};

export type AuctionCar = {
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
  endsInMinutes: number; // for demo countdown
  specs: {
    engine: string;
    powerHp: number;
    color: string;
    vin: string;
    owners: number;
  };
  initialBids: Bid[];
  upcomingBids: Array<{
    bidderName: string;
    amount: number;
  }>;
};
```
generate me xano tables that covers this use case, also consider creating user table 

make necesssary api, and please group them in car group

i need a background task that will loop throught the car_auction and checks auction_end if its over, if yes then see who is the highest bidder from car_bid, and save it 
this task must run every 60minutes


----------------

- comments can crash to infinite pushing, when the comment is in the table, 
something like this  
    text bid_source?="web" // web, mobile, api
    
- extension doesn't detect this error query 1_list_auctions_GET verb=GET {
the correct should be query "1_list_auctions_GET" verb=GET {
also the inline comments are ruining the compiling

- i have issue with else if
it supposed to be like this 
    conditional {
      if () {
      }
    
      else {
        conditional {
          if () {
          }
        }
      }
    }

- always ai is adding comments, and its breaking the compiling of the code when comment is inside a block
- ai is generating this 
   features        : ```
          [
            "Twin Turbo"
            "Carbon Fiber Body"
            "Racing Seats"
            "Original Tool Kit"
          ]
          ```
  and its not valid, it has to be like this 

- checking the @143_user.xs@144_car_auction.xs@145_car_bid.xs@146_car_watchlist.xs@148_car_auction_view_history.xs  make function that is a seeder, each tables has a function seeder 
