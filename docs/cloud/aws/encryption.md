hero: <i class="fa fa-cloud"></i> Cloud

# Encryption

Consider the need for access to any keys used to encrypt and store data.
Although this is not specific to AWS, do not assume you have automatic rights to private keys employed to encrypt the data.

Where a third-party provider supplies or uses encryption or compression to store the market data on S3, you will need to check the public and private keys are either made available to you, or held by some form of external service.


