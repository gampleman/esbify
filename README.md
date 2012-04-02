# ESBify

ESBify is a simple DSL for creating the necessary XML files for the ESB framework.

## Instalation ##

    $ gem install esbify
  
should do the trick provided you have a recent enough installation of Ruby. Run

    $ esbify -h
    
to list basic usage.

## Syntax

    !expectations
    
    name:       may_not_have_bangs
    condition:  played(P1, duel, P2) | responded(P1, bang, P2, duel) | played(P1, indians, P2)
    phi:        requires_bang_response(P2)
    test_plus:  lost_life(P2)
    test_minus: played(P2, bang, P3) | responded(P2, bang, P3, _)
    rho_plus:
      + has_no_bangs
    rho_minus:
      - has_no_bangs
    
    ----------
    
    name:       has_no_bangs
    condition:  requires_bang_response℗ | has_no_bangs(P)
    phi:        has_no_bangs_phi(P)
    test_minus: draw(P, X)
    rho_minus:
      - has_no_bangs
    
    
    # comment 
    
    !behaviors
    
    name:   JI plans
    jason:  has_no_bangs(P)
    action: card_expectation(P, bang, 0)



### Headers

`!expectation`, `!behavior`, `!strategy`

Are possible headers saying that the following code will be of that particular type. 

### Expectations

### Behaviors

`name` is an identifier and isn't particularly useful. When omitted, a random number will be used.

`ctl` is a [computation tree logic](http://en.wikipedia.org/wiki/Computation_tree_logic).

The syntax of CTL formulas recognized by NUSMV is as follows:

`ctl_expr` =


`simple_expr`               | a simple boolean expression
---------------             | -------
`( ctl_expr )`              |
`! ctl_expr`                | logical not
`ctl_expr & ctl_expr`       | logical and
`ctl_expr xor ctl_expr`     | logical exclusive or
`ctl_expr xnor ctl_expr`    | logical NOT exclusive or
`ctl_expr -> ctl_expr`      | logical implies
`ctl_expr <-> ctl_expr`     | logical equivalence
`EG ctl_expr`               | exists globally
`EX ctl_expr`               | exists next state
`EF ctl_expr`               | exists finally
`AG ctl_expr`               | forall globally
`AX ctl_expr`               | for all next state
`AF ctl_expr`               | for all finally
`E [ ctl_expr U ctl_expr ]` | exists until
`A [ ctl_expr U ctl_expr ]` | forall until

- `EX p` is true in a state s if there exists a state s′ such that a transition goes from s to s′
and p is true in s′.
- AX p is true in a states iff or all states s′ wherethereisatransitionfromstos′,pistrue
in s′.
- EF p is true in a state s0 if there exists a series of transitions s0 → s1, s1 → s2, ...,
sn−1 →sn suchthatpistrueinsn.
- AF pistrueinastates0 ifforallseriesoftransitionss0 → s1,s1 → s2,...,sn−1 → sn
p is true in sn.
- EG p is true in a state s0 if there exists an infinite series of transitions s0 → s1, s1 → s2,
... such that p is true in every si.
- AG pistrueinastates0 ifforallinfiniteseriesoftransitionss0 →s1,s1 →s2,... p
is true in every si.
- E[p U q] is true in a state s0 if there exists a series of transitions s0 → s1, s1 → s2,
..., sn−1 → sn such that p is true in every state from s0 to sn−1 and q is true in state sn.
- A[p U q]istrueinastates0 ifforallseriesoftransitionss0 → s1,s1 → s2,...,
sn−1 → sn p is true in every state from s0 to sn−1 and q is true in state sn. A CTL formula is true if it is true in all initial states.

---

`jason` is a logic inside the ASL agent.

Both `ctl` and `jason` need to be true to execute `action`, which is a ASL belief that will be added to the agent's belief base.