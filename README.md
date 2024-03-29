# Ludum Dare 49


<p align="center">
  <img src="assets/images/animated_cover.gif"
       alt="A cover image.">
</p>


-   **[Play the game!](https://levilindsey.itch.io/the-eye-of-mount-glower-on)**
-   **[Watch the gameplay](https://youtu.be/PsbyLwgKQr0)**
-   **[Watch this let's-play video from a stranger on the Internet!](https://www.youtube.com/watch?v=bv0djyPlHwQ)**
-   **[See the game-jam ratings](https://ldjam.com/events/ludum-dare/49/ludum-dare-49)**

_In this point-and-click game, you control the vast power of an unstable mountain._

> The heroes of the land aim to ascend **Mount Oh No** to destroy the vessel of your vast power! You must CRUSH THEM! And send them flying! They will FEEL YOUR ANGER!! They think they can scale Mount Oh No?? Not while **The Eye of Glower-On** is watching!

## The jam

Ludum Dare is a semi-annual event where people create a game over the weekend. Ludum Dare is a ranked competition, with a clever voting system that gets more eyes on your game when you in turn rate other games. There are two tracks you can participate in:

-   In the "**Compo**" track, you must create all your own art, music, sounds, etc. from scratch, work by yourself, and finish within 48 hours.
-   In the "**Jam**" track, you can work with a team, you can use art, code, music, sounds, etc. that already existed or was created by someone else, and you get 72 hours to finish.

Additionally, the games all follow some central theme, which is only announced at the start of the jam.

I worked solo and created everything during the event. Except of course for my Scaffolder and Surfacer frameworks (which is fine, you're allowed to use pre-existing code).


<p align="center">
  <img src="assets/images/characters_demo.gif"
       alt="The various characters.">
</p>


### How the game fits the theme

The mountain is unstable! You use frequent earthquakes and falling boulders to stop those pesky heroes in their tracks!

## Controls

Tap, tappity, tap tap!

Mouse or touch!

## Software used

-   [Godot](https://godotengine.org/): Game engine.
-   [Piskel](https://www.piskelapp.com/user/5663844106502144): Pixel-art image editor.
-   [Aseprite](https://www.aseprite.org/): Pixel-art image editor.
-   [Bfxr](https://www.bfxr.net/): Sound effects editor.
-   [DefleMask](https://deflemask.com/): Chiptune music tracker.
-   [Surfacer](https://github.com/SnoringCatGames/surfacer/): A framework that enables procedural path-finding across 2D platforms.
-   [Scaffolder](https://github.com/SnoringCatGames/scaffolder/): A framework that provides some general app infrastructure.

## Getting set up

> **NOTE:** This repo uses [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to include frameworks.

To learn more about how the code works, checkout the [Surfacer](https://github.com/SnoringCatGames/surfacer/) and [Scaffolder](https://github.com/SnoringCatGames/scaffolder/) READMEs.

## Licenses

-   All code is published under the [MIT license](LICENSE).
-   All art assets (files under `assets/images/`, `assets/music/`, and `assets/sounds/`) are published under the [CC0 1.0 Universal license](https://creativecommons.org/publicdomain/zero/1.0/deed.en).
-   This project depends on various pieces of third-party code that are licensed separately. Here are lists of these third-party licenses:
    -   [addons/scaffolder/src/config/scaffolder_third_party_licenses.gd](https://github.com/SnoringCatGames/scaffolder/blob/master/src/config/scaffolder_third_party_licenses.gd)
    -   [addons/surfacer/src/config/surfacer_third_party_licenses.gd](https://github.com/SnoringCatGames/surfacer/blob/master/src/config/surfacer_third_party_licenses.gd)
    -   [src/config/third_party_licenses.gd](./src/config/third_party_licenses.gd)


<p align="center">
  <img src="assets/images/gui/loading.gif"
       alt="An animated GIF.">
</p>
