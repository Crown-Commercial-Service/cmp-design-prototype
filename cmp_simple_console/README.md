
# Example Journey

Prototype to prove

- CCS Front End Kit
- Agreement design repository approach


Approach is to copy the GOV.UK kit from npm, and overwrite
key elements using 

- text replace (hack)
- adding minimum source components to overwrite GOV.UK elements

This demonstrates we can use the GOV.UK kit with a minimum set of additions.


## Principles

- use GOV.UK style names -- don't rename everything 'govuk' to 'ccs' just for the sake of it 

## Build

- npm install
- gulp

## Deploy

Using Heroku

e.g. with app name fierce-ocean-60910
``` 
heroku container:push web -a fierce-ocean-60910
heroku container:release web -a fierce-ocean-60910 
heroku open -a fierce-ocean-60910 
heroku logs -a fierce-ocean-60910 
```