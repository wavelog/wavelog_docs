# ADIF File Can't Be Imported

In most cases, this is caused by an ADIF-file that do not follow the specifications.

Each line also needs to be terminated by an  `<EOR>` tag.

The length attribute of each ADIF tag has to contain the exact length of the following content.

If you can't figure out the problem, raise an issue in Github. Include the ADIF-file you are having trouble with. It is impossible to know why the import fails without the file.

Your ADIF file can also be validated in the validator found online:

https://www.rickmurphy.net/adifvalidator.html

If your ADIF file contains too many QSOs, and you get a time out, divide your file into smaller files. You can find a program here that is called Adif Divider: http://sp7dqr.pl/en/converters.php (Link untested)

Furthermore make sure your ADIF contains only QSOs of the originator-Call which is set at the chosen station-location. You can bypass the check (not recommended!) by ticking the following checkbox at ADIF-Import:

<img width="763" alt="image" src="https://github.com/user-attachments/assets/20d197eb-91da-490d-b631-055213db1d1c">
