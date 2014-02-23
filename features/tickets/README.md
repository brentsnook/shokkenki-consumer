Tickets are Shokkenki's take on the contract part of [consumer driven contracts](http://martinfowler.com/articles/consumerDrivenContracts.html).

A ticket serialises all of the interactions spelled out by a consumer. A provider can then take a ticket and fulfil it by proving that it behaves in the way expected.

A shokkenki ticket is a JSON file containing details of the consumer that created it, the provider that the consumer relies on and each interaction that the consumer requires.