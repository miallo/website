# My private blog

Stack:
- [hugo](https://gohugo.io) site generator
- [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme
- (highly adapted) [image gallery](https://github.com/thisdev/hugo-gallery-shortcode) shortcode. It works like this:
    - In the posts folder you create subfolders for each gallery and put the images into it
    - You name the images (optionally starting with a leading number for sorting) with their caption (Umlauts need to be written as e.g. \ue). E.g. `L\oewenrudel bei der Jagt.jpg`
    - In the index.md in the same dir where you created the photo-folder you write `{{< image-gallery "gallery-dubai" >}}` (if you named the folder "gallery-dubai")

## develop

Run `hugo server --buildDrafts` and then open http://localhost:1313 for a live preview.

Execute `./publish` for building the site and syncing it to the server (you obviously need credentials for that which you (hopefully) don't have if you are not me)
