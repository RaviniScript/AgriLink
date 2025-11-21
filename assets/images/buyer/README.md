Place buyer-related images here.

Recommended structure and filenames (use these names so code can load them automatically):

- carousel/
  - carousel_1.png   <- FIRST slide (this one should include the text overlay)
  - carousel_2.jpg
  - carousel_3.jpg

- fruits/
  - avocado.png
  - pineapple.png
  - banana.png
  - ...

- vegetables/
  - carrot.png
  - pumpkin.png
  - broccoli.png
  - ...

Icon folder:
- assets/icons/buyer/
  - icon_fruits.png
  - icon_vegetables.png
  - (other icons)

Guidelines:
- Recommended size for carousel images: 1080 x 600 (or any high-res image). The first image (`carousel_1.png`) should already contain the banner text; the app will not overlay text except for that first slide.
- Product images: square JPG/PNG; 800x800 or similar; the app will scale to card size.

After you add images, run:

```powershell
flutter pub get
flutter clean
flutter run -d <deviceId>
```

If you want alternative names, tell me and I will update the code accordingly.
