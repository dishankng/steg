# steg
An improved steganography algorithm implemented in MATLAB


Introduction:

In this era of Internet every digitized object is transferable and exchangeable over
internet for various purposes. As every computer user knows that there are numerous
security threats for digitized objects hence methods like steganography are getting
more importance day by day.

Though steganography is a very old method of hiding information behind some
object, but still this is very effective for secure data transfer and data exchange. Image
Steganography is a thriving research area of information security where secret data is
embedded in images to hide its existence while getting the minimum possible
statistical detectability.

In this project we started with the implementation of basic LSB substitution algorithm
followed by a modified and slightly improved algorithm using LSB Substitution.
Then, frequency domain techniques such as Discrete Wavelet Transform(Haar) were
implemented and the results were compared. Graphical User Interface was developed
accommodating all the various techniques for the ease of demonstration.



SMARTER LSB ALGORITHM:
---------------------

Encoding Algorithm:
---------------------
Inputs : Cover Image, Message Image
1. Calculate coordinates of cover from where group bits have to be stored using size
of message image(messageSize)
2. Set pointers to 1st cover pixel and first message pixel
3. Obtain the three 8 bit colour bytes from message pixel
4. Divide the current colour's 8 bits into 2 halves- messageLeft and messageRight
5. Divide the 8 LSBs of cover pixel into 2 groups- pixelA and pixelB as explained
above
6. Calculate weightage of pixelA and pixelB
7. Case 1: Calculate error=error1 assuming messageLeft is stored in pixelA and
messageRight is stored in pixelB
8. Case 2: Calculate error=error2 assuming messageLeft is stored in pixelB and
messageRight is stored in pixelA
9. if error1>error2 then go to step 12
10. Apply case 1
11. Store groupBit = 0 at current group bit coordinate
12. Go to step 14
13. Apply case 2
14. Store groupBit = 1 at current group bit coordinate
15. Move to next group bit coordinate
16. Move to next cover pixel
17. Store the no. of cover pixels used (count)
18. If all message pixels embedded go to step 22
19. If current message Pixel embedded, move to next message pixel and go to step 3
20. Move to next message colour byte. Go to step 4
21. move to step 2
22. Return stego image
Outputs : stego-image, count, messageSize

Decoding Algorithm
---------------------
Inputs : stego-image, count, messageSize
1. Calculate coordinates from where groupBits have been stored in stego-image
using messaageSize
2. Set pointer to 1st stego-image pixel
3. Create uint8 3d matrix retrievedMessage corresponding to messageSize
4. Divide current stego-image pixel into pixelA and pixelB
5. Divide current retrievedMessage colour byte into messageLeft and messageRight
6. Go to group bit Coordinate in stego-image to get group bit
7. if group bit = 1 go to step 9
8. Set pixelA bits in messageLeft
9. Set pixelB bits in messageRight
10. Set pixelA bits in messageLeft
11. Set pixelB bits in messageRight
12. Move to next cover pixel
13. Go to next group Bit coordinate
14. Decrement count
15. If count =0 go to step 17
16. If one retrievedMessage pixel completed move to next retrievedMessage pixel
17. Go to to step 3
18. Move to next retrievedMessage colour byte
19. Go to step 4
20. Return retrieved Image

Output : Retrieved image
