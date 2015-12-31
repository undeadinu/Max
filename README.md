# Max
The better font manager for OS X

(1) Max (named after [Max Miedinger, the designer of Helvetica](https://en.wikipedia.org/wiki/Max_Miedinger)), is a CLI for installing and managing 3rd party fonts on OS X.

(2) [Homebrew](http://brew.sh) for fonts.

# Installation
  ```curl -s -l https://raw.githubusercontent.com/Colton/Max/master/install.sh | bash```

# Quickstart

  **Install a font**

  ```max install <font name>```

  **Install a font family**

  ```max install --family <font family name>```

  **Preview a font/family**

  ```max preview (--family) <font/family name>```

  Browse all of the available fonts in the [Registry](https://github.com/Colton/Max/tree/master/.Registry)

# Submitting a font/family

### Font
1. To submit a font to Max, first clone this repository. Next, create a JSON file with 3 properties. The ```name``` of the font, a direct URL to ```download``` the font, and the ```SHA256``` hash of the font (```shasum -a 256 <font location>```). This hash must be valid or Max will not install the font. See: [this example font JSON file](https://github.com/Colton/Max/blob/master/.Registry/Fonts/firamono-regular.json).

2. Copy the JSON file to /.Registry/Fonts/. Make sure the name of the file is the all-lowercase version of the ```name``` you entered in the JSON file.

3. Submit a pull request.

### Family
1. To submit a font family to Max, first submit the individual fonts making up the family. Each font included in the family must be in the Registry before-hand.

2. Make a new JSON file with 2 properties: ```name``` and  ```fonts```. The ```name``` is the name of the font family, and ```fonts``` is an array of the fonts that make up the family. See: [this example family JSON file](https://github.com/Colton/Max/blob/master/.Registry/Families/fira.json).

3. Copy that file to the /.Registry/Families directory with the name being the all-lowercase version of the ```name``` property of the family's JSON file

4. Submit a pull request.

# License
Code is under the [Apache License](http://choosealicense.com/licenses/apache-2.0/).
