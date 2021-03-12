IMPORTANT:
If you have any issues while filling up the data due to 'substitution' reasons, it is because of the '&' char.
This is because Oracle by default sets the '&' char as the substitution char.

To avoid being prompt to substitute, please do as follow:
1) In every table that prompts for substitution, replace all '&' by '\&'

2) Run the following SQL statement: SET ESCAPE '\';

3) You can now insert needed data without being prompt for substitution.
