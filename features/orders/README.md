A consumer uses orders to specify the provider interactions that it is interested in and how it expects a provider to respond.

Each RSpec context may define several orders, one for each relevant interaction with a provider.

An interaction can have the following:

- A label - so that it can be easily identified
- A request - used to match actual requests
- A response - used to specify the response that the consumer expects
- Required fixtures - detailing fixtures that the interaction requires to be established on the provider