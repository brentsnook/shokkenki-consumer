Sometimes things go wrong and you need to take a closer look at what is happening.

Shokkenki consumer assumes that:

- any interactions that you tell it about must be excercised by at least one request
- any requests a stubbed provider receives must match an interaction

This is to ensure that a ticket is a true representation of the consumer-driven contract; it should include **all** of and **only** the interactions required.

When Shokkenki (or your spec) fails, you can can ask the stubber about what is going on. Combine this with interactive debugging tools like [Pry](http://github.com/pry/pry) and you should be able to find out what is going wrong.

If you are still having trouble, please try the [mailing list](http://groups.google.com/forum/#!forum/shokkenki) or [raise an issue](http://github.com/brentsnook/shokkenki-consumer/issues) to let us know how we can make troubleshooting easier.