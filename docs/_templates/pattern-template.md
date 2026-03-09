# Pattern Name

## Context

This problem appears in modern distributed systems when:

-   ...
-   ...
-   ...

------------------------------------------------------------------------

## Problem

Without this pattern:

-   risk of inconsistencies
-   difficult service coordination
-   unreliable event propagation

------------------------------------------------------------------------

## Solution

The pattern consists of:

1.  ...
2.  ...
3.  ...

> Core idea: ensure reliability and clear separation of
> responsibilities.

------------------------------------------------------------------------

## Architecture

``` mermaid
flowchart LR
A[Component A] --> B[Component B]
B --> C[Component C]
```

------------------------------------------------------------------------

## Example

Example scenario:

-   Service A writes to database
-   Event stored in outbox table
-   Event published to Kafka

------------------------------------------------------------------------

## Advantages

-   improved reliability
-   better decoupling
-   easier scalability

------------------------------------------------------------------------

## Drawbacks

-   additional complexity
-   operational overhead

------------------------------------------------------------------------

## When to Use

Use this pattern when:

-   building distributed systems
-   integrating multiple services
-   ensuring data consistency across boundaries

------------------------------------------------------------------------

## References

-   Designing Data-Intensive Applications
-   Official documentation
