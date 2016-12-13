Dodge The Potholes
Team: JYPC
Members: Jonathan Buie, Young-Hoon Kim, Peter Murphy, and Colby Stanley
___________________________________________________________________________________________

Building the app:
To build the app, open the DodgeThePotholes.xcworkspace file instead of the
usual .xcodeproj file. This is because our project relies on cocoa pods for 
the Firebase API. 
___________________________________________________________________________________________

Playing the game:
To control your car place your phone parallel to the ground and lean the 
device left and right for optimal results. 
___________________________________________________________________________________________

Hitting powerups:

X2 and X3: The user score gained is multiplied by 2 and 3 times respectively for 15 seconds.

Invincibility: The user's vehicle becomes a monster truck or tank depending on unlocks and
the user's vehicle is invincible to powerdowns and obstacles for 18 seconds.

+1UP: The user gains  an addition tire (life) up to four lives.

Wrap Around: This allows the user's car to wrap around to the other side of the screen for 15 seconds
____________________________________________________________________________________________

Hitting powerdowns:

Cell Phone: Users are bombarded with notifications that block their view of the car (text messages) 
when they hit a cell phone.

Bottle: When users hit a bottle, the controls are inverted, the music slows down, and their 
perception is inhibited (vision is blurred).
____________________________________________________________________________________________

Hitting obstacles:

-All obstacles result in the loss of a tire/life and the user is temporarily invunerable to
other obstacles

Obstacles Include: Traffic Zones (marked by traffic cones and barricades), Trees, Bushes, People,
Dogs, Black Ice, Other Vehicles, and POTHOLES! 
____________________________________________________________________________________________

Store Items/Unlockables:

-In the store, the currency gathered during the game can bue used to make purchases that
enhance the user experience.

Items/Unlockables Include: New Cars, Extra Lives, a Tank, and New Songs that can be played
in the background during the game.
_____________________________________________________________________________________________

Settings:

-Users are able to turn on/off sound effects (sfx) and music to customize their experience.
-Additionally, new songs purchased in the store can be set as the In Game Music.
-Each of these settings persists.
_____________________________________________________________________________________________

Leaderboard:

-The Leaderboard displays the top 10 all time scores, and if a user's score appears in the top
10, their score will have a yellow font instead of the default white.


Additional Note:
If there are any warnings after building in XCode, run: Product > Clean
If there is an older version of CocoaPods that exists there may be a warning, but not an issue with the code.
