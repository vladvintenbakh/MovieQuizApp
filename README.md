## **MovieQuiz**

MovieQuiz is a quiz app to test one's knowledge of the 250 top-rated movies according to IMDb.

## **Links**

[Figma Design](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)

[IMDb API](https://developer.imdb.com/documentation/api-documentation/?ref_=/documentation/_PAGE_BODY)

[Fonts](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **App description**

- A one-screen quiz app with questions about the 250 top-rated movies according to IMDb. The user sequentially answers questions about the rating of each movie. The user's stats and high score are displayed after each round played. The goal is to answer all 10 questions in a single round correctly.

## **Functional requirements**

- A Launch screen is shown after launching the app.
- After launching the app, the question screen is displayed. It has the question text, an image, and two answer options ("Yes" and "No"). Only one of the answer options is correct.
- Each quiz question is constructed based on the movie's IMDb rating out of 10. For example: "Is this movie's rating greater than 6?"
- The user can click one of the answer options and receive feedback on whether the answer is correct. The feedback is in the form of the image frame turning green (for correct) or red (for incorrect) for a short period of time.
- Next question is automatically displayed 1 second after clicking one of the answer options.
- At the end of each 10-question round, an alert that shows the user's stats and high score is displayed. The alert also contains the "Play again" button that allows the user to play another round.
- The stats summary contains the current round result (the number of correct answers out of 10), number of quizzes played, high score (the score and date/time when it was achieved), average accuracy across the quiz rounds played so far.
- If there is an error loading the data, an alert is displayed to inform the user that something went wrong. The alert also contains a retry button.

## **Non-functional requirements**

- Minimum deployment version: iOS 13.
- Supports portrait orientation only.
- The UI elements adapt to different iPhone screens (iPhone X or higher).
- The screen layouts follow the Figma design.
