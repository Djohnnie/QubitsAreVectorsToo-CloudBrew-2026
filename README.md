# Qubits Are Vectors Too

**The Math Behind Quantum Computing / CloudBrew 2026**

A pure qubit state is represented by a normalized vector in ℂ² up to global
phase, and quantum gates act on that vector through
matrix multiplication. **Qubits Are Vectors Too** introduces the mathematics
behind quantum computing for a developer audience, connecting physical
intuition, complex amplitudes, linear algebra, quantum circuits, and Q#.

The 62-slide presentation follows five chapters. **Introduction** explores
motivation, quantum phenomena, and hardware. **Quantum Math** introduces basis
states, superposition, normalization, and complex numbers. **Vectors** connects
those ideas to column vectors, the Bloch sphere, and tensor products.
**Quantum Logic** explains gates through circuits, worked matrix
multiplications, and geometric rotations. **Quantum Code** brings the same
states and operations to life in six Q# examples.

Open the [offline slide preview](slides/index.html) to navigate the deck with
the arrow keys, or browse the individual slides below. Each slide has its own
TL;DR box and a detailed explanation of its content and place in the story.
The six [runnable Q# projects](examples/) on slides 56–61 use a local
simulator; no Azure account or quantum hardware is required.
`_resources/code` contains display copies of the first five snippets.

## Presentation slides

### Slide 1 / Qubits Are Vectors Too

> **TL;DR:** Represent a pure qubit state by a vector and apply a gate by
> multiplying that vector by a unitary matrix.

![Qubits Are Vectors Too](slides/slide-01.svg)

The opening slide introduces the session, its subtitle **The Math Behind
Quantum Computing**, and presenter Johnny Hooyberghs at
[CloudBrew 2026](https://www.cloudbrew.be/) in Mechelen, Belgium.

The title states the talk's central idea: familiar linear-algebra tools can
explain quantum states and their evolution. The emphasis is on developer
intuition grounded in mathematics, rather than treating quantum computing as
an opaque collection of physical effects.

### Slide 2 / Johnny Hooyberghs

> **TL;DR:** The speaker approaches quantum computing from a software
> developer's perspective.

![Johnny Hooyberghs](slides/slide-02.svg)

A speaker portrait accompanies an introduction covering .NET custom application
development, Azure Cloud, and GenAI. The slide lists 19 years of professional
experience, an interest in quantum computing, public speaking and training,
and Microsoft MVP recognition in Developer Technologies and Microsoft Azure
since 2020.

The Belgium silhouette is adapted from [Pixabay](https://cdn.pixabay.com/photo/2016/10/21/19/03/belgium-1758814_1280.png).

This background positions the session as a bridge from everyday software
engineering to quantum concepts. The audience is invited to use its existing
technical reasoning skills while learning the mathematical model.

### Slide 3 / Scan to visit the repository

> **TL;DR:** Scan the code to follow the CloudBrew slides or run their Q# examples.

![Scan to visit the repository](slides/slide-03.svg)

Scanning or clicking the QR code opens
[this CloudBrew repository](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026).
The offline preview displays an image; choose **Open SVG** to click the embedded link.

### Slide 4 / Agenda

> **TL;DR:** The journey runs from quantum motivation to mathematics, vectors,
> gates, and working Q# code.

![Agenda](slides/slide-04.svg)

Five numbered chapters organize the talk: **Introduction**, **Quantum Math**,
**Vectors**, **Quantum Logic**, and **Quantum Code**. Each chapter is paired
with a guiding question, beginning with what quantum computing is and why
it matters, and ending with how Q# expresses the ideas.

The order is deliberate. Physical examples provide motivation; amplitudes
establish the state model; vectors make that model concrete; gates explain
how states change; and code demonstrates those changes in a simulator.
The agenda frames these as one connected progression rather than five
independent topics.

### Slide 5 / Introduction

> **TL;DR:** Chapter 1 asks what quantum computing is and why we might need it.

![Introduction](slides/slide-05.svg)

The first chapter divider introduces the question **What is quantum computing
and why do we need it?** A large chapter number and sparse layout mark the
transition from introductory logistics to the subject itself.

The following slides build motivation through exponential growth and potential
problem domains, then introduce spin, superposition, entanglement, and examples
of hardware. This chapter supplies the context for the mathematical treatment
that follows.

### Slide 6 / Paper folding to the Moon: question

> **TL;DR:** Repeated doubling can turn a tiny starting quantity into an
> enormous one surprisingly quickly.

![Paper folding to the Moon: question](slides/slide-06.svg)

The slide asks how many theoretical folds would make a sheet of A4 paper
thick enough to reach the Moon. The assumptions are explicit: the paper starts
at 0.1 mm thick, every fold doubles its thickness, and the average Earth–Moon
distance is about 384,400 km. The problem is expressed as
0.1 mm × 2ⁿ ≥ 384,400 km, with the answer left open.

A vector illustration connects Earth's curved surface to the Moon with a
stack of paper layers. It is a thought experiment, not a physically achievable
folding exercise, and the illustration is not to scale. Its role is to build
intuition for exponential growth before the state-space discussion.

### Slide 7 / Paper folding to the Moon: answer

> **TL;DR:** Just 42 theoretical doublings take 0.1 mm beyond the average
> Earth–Moon distance.

![Paper folding to the Moon: answer](slides/slide-07.svg)

After 41 doublings, 0.1 mm × 2⁴¹ ≈ 219,902 km, still short of the
384,400 km average Earth–Moon distance. One more doubling gives about
439,805 km, so **42** is the first fold to cross the threshold.
The same growth rule appears later: each additional qubit doubles the
number of entries in an expanded pure-state column.

### Slide 8 / Drug discovery & materials

> **TL;DR:** Estimating a catalyst’s electronic energy is a concrete quantum
> simulation target, not a demonstrated advantage in drug discovery.

![Molecular chemistry and DNA](slides/slide-08.svg)

Where along a reaction pathway does the energy peak? Estimate the electronic
energy at several arrangements of the nuclei, then compare the resulting
barriers for two candidate catalysts. Interacting electrons make those
estimates difficult. A useful quantum simulation would need to reach the
required accuracy at a competitive cost compared with classical chemistry
methods; the fact that molecules are quantum does not establish a speedup.

### Slide 9 / Optimization & climate logistics

> **TL;DR:** Minimize fleet emissions subject to delivery deadlines. A hybrid
> solver uses a quantum device; a quantum-inspired solver runs classically.

![Global logistics and supply chains](slides/slide-09.svg)

A single truck might emit less than two but miss a delivery window. Reject
routes that miss a deadline or exceed truck capacity, then compare the
estimated emissions of the feasible plans. A hybrid method might send a
subset of routing choices to a quantum processor and check the candidate
plan classically. A quantum-inspired method borrows ideas from quantum
physics but runs entirely classically. Compare either against a classical
routing solver on the same constraints, time budget and emissions measure.

### Slide 10 / Post-quantum cryptography & security

> **TL;DR:** Post-quantum cryptography runs on classical hardware now;
> migration need not wait for a fault-tolerant quantum computer.

![Cryptography and security](slides/slide-10.svg)

A sufficiently large fault-tolerant quantum computer could break the
mathematical assumptions behind RSA and elliptic-curve cryptography. The
work today is to inventory where those algorithms are used and distinguish
two jobs when planning replacements: establishing a shared secret and
verifying who signed a message. [NIST’s post-quantum standards](https://csrc.nist.gov/projects/post-quantum-cryptography)
specify ML-KEM for key establishment (FIPS 203), and ML-DSA and SLH-DSA
for digital signatures (FIPS 204 and 205). Neither job needs a quantum link.

### Slide 11 / Electron spin

> **TL;DR:** Spin provides a physical example of two basis states and
> their superposition.

![Electron spin](slides/slide-11.svg)

The arrows label the two spin states along the **z** axis; an electron is not
a spinning ball. The drawing is schematic. A normalized example is
`(|↑z⟩ + |↓z⟩)/√2`. Square the magnitude of each amplitude to get the
probability of its outcome: `(1/√2)² = 1/2`. One measurement along z yields
one result, not simultaneous observations of up and down.

### Slide 12 / Schrödinger's cat

> **TL;DR:** The cat thought experiment highlights the tension between
> quantum superposition and definite observed outcomes.

![Schrödinger's cat](slides/slide-12.svg)

Suppose a detector couples the fate of a cat to a microscopic decay. In an
idealized quantum description, “no decay, alive” and “decay, dead” are
alternatives in a joint state of the system. Opening the box gives a single
outcome. The two pictures label those alternatives; they do not show two
conditions an observer sees at once.

### Slide 13 / Entangled electrons

> **TL;DR:** This Bell state gives matching bits when both qubits are measured
> in the Z basis. Matching bits alone do not prove entanglement.

![Entangled electrons](slides/slide-13.svg)

For the Bell state `(|00⟩ + |11⟩)/√2`, measuring both qubits in the
computational (Z) basis yields `00` or `11`, each with probability ½. A
classical source that flips one fair coin and sends two copies of its bit
gives exactly the same counts. What distinguishes the Bell state is its
coherent superposition: its state vector cannot be factored into separate
one-qubit states. [Q# example 5 (slide 60)](#slide-60--entangle-two-qubits-with-h-and-cnot)
inspects the two nonzero amplitudes, each exactly `1/√2` (displayed as
`0.7071`); it does not log measurement shots.

### Slide 14 / A Feynman quote

> **TL;DR:** Quantum mechanics challenges everyday intuition; a precise
> mathematical model is more useful than forced classical analogies.

![A Feynman quote](slides/slide-14.svg)

Large yellow quotation marks frame Richard Feynman's documented
remark "I think I can safely say that nobody understands quantum mechanics",
with the source *The Character of Physical Law* (1965) shown beneath the
attribution. There is no visible slide title, giving the quotation and
attribution the full visual focus.

The slide provides a pause after spin, the cat, and entanglement. Its purpose
is to acknowledge that these ideas are counterintuitive, not to suggest that
they cannot be modeled or used. A biographical line notes Feynman's birth
on 11 May 1918, his 1965 Nobel Prize in Physics, and his death on
15 February 1988; these dates are supported by the
[Nobel Prize facts page](https://www.nobelprize.org/prizes/physics/1965/feynman/facts/).

### Slide 15 / A quantum computer

> **TL;DR:** A quantum computer includes substantial supporting hardware,
> not just the qubits themselves.

![A quantum computer](slides/slide-15.svg)

A dilution refrigerator cools a superconducting qubit chip so thermal
energy is small compared with the energy gap between its two computational
levels. The suspended stages cool the wiring on its way from room-temperature
electronics to the chip. The refrigerator is supporting hardware, not the
processor itself; other qubit platforms need different infrastructure.

### Slide 16 / Vacuum tube computing

> **TL;DR:** Early classical hardware is a reminder that computing platforms
> evolve dramatically over time.

![Vacuum tube computing](slides/slide-16.svg)

A historical computing module fills the slide with vacuum tubes, resistors,
and wiring. The visible components contrast with today's compact classical
computers and with the quantum apparatus on the preceding slide.

The comparison provides perspective on hardware maturity: the physical form
of an early computing platform is not necessarily its final form. It is an
analogy about engineering development, not evidence that quantum hardware
will follow the same timetable or replace classical machines in every role.
The slide also distinguishes the concept of computation from any one
physical implementation.

### Slide 17 / Superconducting qubits

> **TL;DR:** A superconducting circuit can act as an artificial atom. Driving
> a qubit, coupling two qubits and reading a result are different operations.

![Superconducting qubits](slides/slide-17.svg)

Two low-energy levels of a nonlinear Josephson-junction circuit encode `0`
and `1`. The photograph shows cryogenic wiring, not enough detail to
identify the chip or say whether its frequencies are fixed.
[QuTech’s Starmon-5 fact sheet](https://qutech.nl/wp-content/uploads/2024/03/Starmon5_FactSheet_240316.pdf)
gives a concrete example: a microwave drive rotates one qubit; coupling
buses connect selected qubits, and flux controls tune them for a two-qubit
gate. To measure a qubit, probe its readout resonator: the response depends
on the qubit state. Cooling and calibration help preserve the state during
these physical operations; neither guarantees an error-free gate.

### Slide 18 / Neutral atom qubits

> **TL;DR:** Pasqal ORION is an analog neutral-atom computer: program the
> atom layout and laser pulses, then let the array evolve.

![Neutral atom qubits](slides/slide-18.svg)

The cabinet is labeled **Pasqal ORION**. In [Pasqal’s analog QPUs](https://docs.pasqal.com/qpu-emulators/qpus/),
optical tweezers position individual atoms in vacuum. A laser can excite an
atom to a Rydberg state, shifting the energy needed to excite its neighbors.
Choosing the atom spacing changes the interaction strength. Programming the
laser pulse controls how the array evolves before measurement. This is not
a list of discrete circuit gates: some *other* neutral-atom platforms use
Rydberg interactions to implement digital entangling gates.

### Slide 19 / Topological qubits & Majorana quasiparticles

> **TL;DR:** A proposed Majorana encoding stores a qubit across separated
> modes. Measuring parity is not the same as demonstrating a protected braid.

![Topological qubits and Majorana quasiparticles](slides/slide-19.svg)

In the proposal, information belongs to the joint state of spatially
separated Majorana modes, not to any one mode. That separation could make
the encoding less sensitive to local disturbances. Exchanging the modes
in a specified order (braiding) would transform the encoded state.

[Microsoft’s experiment in InAs–Al devices](https://doi.org/10.1038/s41586-024-08445-2)
reports a single-shot measurement of fermion parity (even or odd), and
considers both topologically trivial and nontrivial explanations. Neither
that measurement nor the device photograph shows a protected braid.

### Slide 20 / Quantum Math

> **TL;DR:** Chapter 2 replaces loose analogies with amplitudes and the rules
> they must satisfy.

![Quantum Math](slides/slide-20.svg)

The second chapter divider asks **Is math important in quantum?** Its large
chapter number signals a change from motivation and physical examples to
the language needed to calculate quantum behavior.

The next sequence builds the model one step at a time: classical values,
quantum basis states, superposition, normalization, complex amplitudes,
and multi-qubit expansions. Each addition answers a specific question
about what information a quantum-state description must contain.

### Slide 21 / Classical bits

> **TL;DR:** A classical bit has one of two values: 0 or 1.

![Classical bits](slides/slide-21.svg)

Large numerals 0 and 1 appear side by side with no additional mathematical
machinery. This establishes the familiar reference point from classical
computing before introducing quantum notation.

For a definite classical bit, one value describes the stored state.
Uncertainty about that value can be modeled with probabilities, but that
is not the same as the complex-amplitude description introduced for qubits.
The simplicity of the slide makes the contrast in the following progressive
build easier to follow.

### Slide 22 / Quantum bits or qubits

> **TL;DR:** |0⟩ and |1⟩ name the computational-basis states of a qubit.

![Quantum bits or qubits](slides/slide-22.svg)

A pure qubit state is represented by a normalized vector in ℂ². In the
computational basis we write it as α|0⟩ + β|1⟩, with |α|² + |β|² = 1.
Multiplying both amplitudes by the same phase leaves the physical state unchanged.

These two states form the computational basis used throughout the talk.
A computational-basis measurement of a qubit prepared in |0⟩ returns 0
with certainty, and one prepared in |1⟩ returns 1 with certainty.
They are the building blocks for more general states, not the complete
list of pure states a qubit can occupy.

### Slide 23 / Qubits in superposition

> **TL;DR:** A general pure qubit state combines the basis states as
> α|0⟩ + β|1⟩.

![Qubits in superposition](slides/slide-23.svg)

In α|0⟩ + β|1⟩, α and β are **amplitudes**, not probabilities.
Squaring their magnitudes gives the probabilities |α|² and |β|² for
0 and 1 in the computational basis. A change of relative phase can
leave both probabilities unchanged yet affect the result after a later
gate combines the amplitudes.

### Slide 24 / Normalized qubit amplitudes

> **TL;DR:** The squared magnitudes of a qubit's amplitudes must sum to one.

![Normalized qubit amplitudes](slides/slide-24.svg)

The superposition expression gains the condition |α|² + |β|² = 1.
Computational-basis measurement returns 0 with probability |α|² and
1 with probability |β|², so normalization ensures the total probability
is 100%.

The absolute-value bars matter because the coefficients may be complex.
For real positive amplitudes the rule reduces to squaring ordinary numbers,
but the magnitude-squared form works generally. This condition also says
that the state vector has unit length, establishing the link to the vector
chapter before column notation appears.

### Slide 25 / Complex qubit amplitudes

> **TL;DR:** Amplitudes can be complex numbers, and phase carries information
> that probabilities alone do not show.

![Complex qubit amplitudes](slides/slide-25.svg)

The final step of the build writes α = a + bi and β = c + di, where
a, b, c, and d are real and i² = −1. Together with normalization, this
turns the earlier symbolic expression into a more precise mathematical
description.

For α = a + bi, the probability contribution is |α|² = a² + b²,
and similarly |β|² = c² + d². Different relative phases can give the same
immediate measurement probabilities but different behavior under later
gates. A shared global phase, by contrast, does not change the physical
state's observable predictions.

### Slide 26 / Two qubits: four amplitudes

> **TL;DR:** A general two-qubit pure state needs one amplitude for each
> of four joint basis states.

![Two qubits: four amplitudes](slides/slide-26.svg)

The state expands to α|00⟩ + β|01⟩ + γ|10⟩ + δ|11⟩.
The binary-ordered kets describe joint outcomes for the two qubits, and
each has its own complex amplitude. Their squared magnitudes must
collectively sum to one.

This is more than putting two independent single-qubit descriptions next
to each other. Some joint states can be constructed from independent
qubit states, while entangled states cannot. The four-amplitude expression
is general enough to describe both, preparing the ground for tensor
products and the Bell-state example.

### Slide 27 / More qubits, exponentially more amplitudes

> **TL;DR:** A general n-qubit pure-state vector has 2ⁿ amplitude entries.

![More qubits, exponentially more amplitudes](slides/slide-27.svg)

Explicit expansions for two, three, and four qubits show four, eight,
and sixteen amplitudes respectively, one per computational-basis state
in binary order. These are entries, not independent physical parameters:
the squared magnitudes sum to one, and a global phase has no observable effect.

This returns to the paper-folding intuition: adding one qubit doubles
the dimension of the state space. It helps explain why storing a general
state vector on a classical simulator becomes expensive. It does not mean
that measurement exposes all 2ⁿ amplitudes at once or that quantum
computers automatically solve every exponential problem efficiently.

### Slide 28 / Vectors

> **TL;DR:** Chapter 3 makes the amplitude model concrete with vectors
> and geometry.

![Vectors](slides/slide-28.svg)

A pure one-qubit state has two equivalent descriptions here: an amplitude
column and a point on the Bloch sphere. The examples |0⟩, |1⟩ and |+⟩
connect column entries to angles. Tensor products then build four-entry
columns for two qubits and eight-entry columns for three. These are the
columns on which the gate matrices in the next chapter act.

### Slide 29 / The Bloch sphere

> **TL;DR:** The Bloch sphere represents a single pure qubit state as
> a direction in three-dimensional space. Unit vectors in ℂ² modulo global
> phase form the complex projective line CP¹, a projective space, not a vector space.

![The Bloch sphere](slides/slide-29.svg)

The axes identify physical directions: +z is |0⟩, −z is |1⟩, and +x
is |+⟩. Those meanings stay fixed even when a later diagram shows the
sphere from a different angle. The highlighted direction |φ⟩ represents
one particular pure state.

The north and south poles correspond to |0⟩ and |1⟩. Other surface
directions represent superpositions, with polar and azimuthal angles
encoding amplitude balance and relative phase. Global phase is omitted,
so this is a representation of the physical pure state, not a literal
plot of two complex amplitude entries or of an electron's trajectory.
The interior of the ball represents mixed states; its center is the
maximally mixed state. See [IBM Quantum’s Bloch sphere explanation](https://quantum.cloud.ibm.com/learning/en/courses/general-formulation-of-quantum-information/density-matrices/bloch-sphere).

### Slide 30 / Ket zero

> **TL;DR:** |0⟩ is the column vector [1, 0]ᵀ and sits at the Bloch
> sphere's north pole.

![Ket zero](slides/slide-30.svg)

The first worked state sets α = 1 and β = 0, so the expansion is
1|0⟩ + 0|1⟩. The normalization calculation resolves to 1 + 0 = 1,
and the equivalent column vector places 1 in the |0⟩ row and
0 in the |1⟩ row.

A simplified Bloch-circle diagram points upward and labels θ = 0°.
All three views describe the same state: a ket expansion, an ordered
amplitude column, and a geometric direction. Computational-basis
measurement therefore returns 0 with certainty.

### Slide 31 / Ket one

> **TL;DR:** |1⟩ is the column vector [0, 1]ᵀ and sits at the Bloch
> sphere's south pole.

![Ket one](slides/slide-31.svg)

The matching example sets α = 0 and β = 1. Its expansion is
0|0⟩ + 1|1⟩, normalization becomes 0 + 1 = 1, and its column
has a 1 only in the |1⟩ row. Computational-basis measurement
returns 1 with certainty.

The Bloch-circle arrow points downward, with a semicircular arc
marking θ = 180°. Comparing this slide with |0⟩ fixes the row
ordering of the vectors and establishes the opposite poles that
the X and Y gates will exchange.

### Slide 32 / A perfect 50/50 superposition

> **TL;DR:** Equal positive amplitudes of 1/√2 give equal probabilities
> of 1/2, not amplitudes of 1/2.

![A perfect 50/50 superposition](slides/slide-32.svg)

The state |+⟩ = (|0⟩ + |1⟩)/√2 has α = β = 1/√2.
Its column vector contains those two entries, and the normalization
calculation gives 1/2 + 1/2 = 1. Measurement in the computational
basis produces either outcome with 50% probability.

At θ = 90°, |+⟩ lies on the equator along positive x: halfway in polar
angle between the poles, not at the center of the ball.
The word **positive** matters: equal probabilities alone do not
uniquely specify a state. The state |−⟩ has the same probabilities
but a different relative sign, a distinction later demonstrated
by the Z gate.

### Slide 33 / From amplitudes to Bloch angles

> **TL;DR:** For real, nonnegative amplitudes, α = cos(θ/2) and
> β = sin(θ/2).

![From amplitudes to Bloch angles](slides/slide-33.svg)

Three wireframe spheres revisit |0⟩, |1⟩, and |+⟩, each with
a state arrow, angle label, and worked calculation. Inverting
the cosine relationship gives θ = 2 arccos(α), yielding 0°,
180°, and 90° respectively. Nonzero angles are illustrated
with arcs measured from the north pole toward positive x.

The half-angle is essential: the amplitude angle is not the
full Bloch polar angle. This simplified calculation assumes
normalized, real, nonnegative amplitudes. A general pure state
can be written, up to global phase, as
cos(θ/2)|0⟩ + exp(iφ) sin(θ/2)|1⟩, where the second angle φ
describes relative phase around the sphere.

### Slide 34 / Two qubits and the joint state

> **TL;DR:** Two-qubit columns have four rows, ordered as |00⟩,
> |01⟩, |10⟩, and |11⟩.

![Two qubits and the joint state](slides/slide-34.svg)

Four column matrices display the computational-basis states,
each with one 1 and three zeros in the fixed basis order.
A fifth column represents |++⟩ with amplitude 1/2 in every row,
alongside the expansion
(|00⟩ + |01⟩ + |10⟩ + |11⟩)/2.

Squaring each 1/2 gives probability 1/4, so the four outcomes
are equally likely and normalized. The example extends the
single-qubit column convention without changing its meaning:
each row is still an amplitude for a specified basis state.
This equal superposition is a product state, not an entangled one.

### Slide 35 / Tensor product of two state columns

> **TL;DR:** The tensor product combines two independent qubit columns
> into one joint-state column.

![Tensor product of two state columns](slides/slide-35.svg)

The centered calculation takes the columns [α, β]ᵀ and [γ, δ]ᵀ
and combines them with ⊗. In the established basis order,
the result is [αγ, αδ, βγ, βδ]ᵀ. Equivalently,
(α|0⟩ + β|1⟩) ⊗ (γ|0⟩ + δ|1⟩) expands into
the corresponding four joint terms.

The multiplication rule explains the 1/2 entries of |++⟩:
each is the product of two 1/√2 amplitudes. Its scope is
important: this construction describes product states.
A general entangled pure state cannot be factored into
two separate single-qubit columns in this way.

### Slide 36 / Three-qubit tensor product

> **TL;DR:** The expanded column has 2ⁿ entries. For this three-qubit
> product state, three one-qubit columns determine all eight.

![Three-qubit tensor product](slides/slide-36.svg)

The three-qubit column is ordered from |000⟩ through |111⟩.
Each entry is a product of one amplitude from each of the three
one-qubit columns. For example, |+⟩ ⊗ |+⟩ ⊗ |+⟩ has eight nonzero
entries, all equal to (1/√2)³. They are not eight independent inputs:
storing the three factors suffices. An entangled pure state cannot be
specified as a product of one-qubit columns.

### Slide 37 / Quantum Logic

> **TL;DR:** Chapter 4 describes quantum gates as consistent transformations
> of state vectors.

![Quantum Logic](slides/slide-37.svg)

The divider asks **How is quantum probability logical?**
The answer developed in the chapter is that quantum states
change according to precise linear-algebra rules, even when
measurement outcomes are probabilistic.

H, X, Y, and Z are each examined through a circuit,
concrete matrix multiplication, and a geometric interpretation;
CNOT replaces the geometric picture with a worked
entanglement calculation.
The ideal gates here are unitary: they preserve normalization
and are reversible. Measurement is a different kind of operation,
not another reversible gate in this sequence.

### Slide 38 / H gate: circuit and unitary transformation

> **TL;DR:** Hadamard maps the computational basis to equal superpositions:
> |0⟩ → |+⟩ and |1⟩ → |−⟩.

![H gate: circuit and unitary transformation](slides/slide-38.svg)

A single circuit wire carries |0⟩ through an H box to |+⟩.
Below it, the Hadamard matrix has rows (1/√2, 1/√2)
and (1/√2, −1/√2), with each normalization factor written
inside the matrix. The action on both basis states is stated
beside the matrix.

The negative entry distinguishes |−⟩ = (|0⟩ − |1⟩)/√2
from |+⟩. H is not merely a source of random bits: it
changes basis coherently, retaining the phase information
needed to reverse the transformation.

### Slide 39 / H gate: unitary transformation

> **TL;DR:** Applying H twice returns the original state because
> H² = I.

![H gate: unitary transformation](slides/slide-39.svg)

Two worked multiplications show |0⟩ → |+⟩ → |0⟩.
First, the Hadamard matrix multiplies [1, 0]ᵀ to produce
[1/√2, 1/√2]ᵀ. Multiplying that result by H again
gives [1, 0]ᵀ.

In the reverse calculation, the first output entry is
1/2 + 1/2 = 1, while the second is 1/2 − 1/2 = 0.
The addition and cancellation demonstrate interference.
There is no measurement between the gates; measuring the
intermediate superposition would change the experiment
and remove the guaranteed return to |0⟩. A footnote, repeated
on the X, Y, and Z multiplication slides, states that every gate
is unitary: it keeps the vector normalized and can always be undone.

### Slide 40 / H gate: Bloch-sphere rotation

> **TL;DR:** H is a 180° Bloch rotation about the diagonal
> axis (x + z)/√2.

![H gate: Bloch-sphere rotation](slides/slide-40.svg)

A white input vector at +z rotates to a yellow output at +x,
visualizing |0⟩ → |+⟩. The yellow trajectory shows
the rotation path, while a dashed blue line marks the
diagonal rotation axis. The coordinate rule is
(x, y, z) → (z, −y, x).

The axis stays fixed and the x and z directions exchange
roles. The gate turns by **180° about its axis**, even though the
illustrated input (+z) and output (+x) are **90° apart**.
The sphere omits global phase, so this geometric
description is stated up to global phase. The curve is a
two-dimensional projection of a three-dimensional surface
path; appearing inside the drawn circle does not mean
the state has become mixed.

### Slide 41 / X gate: circuit and unitary transformation

> **TL;DR:** X is the quantum bit flip: it swaps |0⟩ and |1⟩.

![X gate: circuit and unitary transformation](slides/slide-41.svg)

The circuit passes |0⟩ through an X box and labels the
output |1⟩. The matrix has rows (0, 1) and (1, 0),
with the two basis-state rules X|0⟩ = |1⟩ and
X|1⟩ = |0⟩ shown explicitly.

For a general state α|0⟩ + β|1⟩, multiplying by
this matrix gives β|0⟩ + α|1⟩. It exchanges the
amplitudes themselves, including any complex values,
rather than measuring the state and conditionally
changing a classical result.

### Slide 42 / X gate: unitary transformation

> **TL;DR:** X exchanges the two entries of the state column,
> and a second X exchanges them back.

![X gate: unitary transformation](slides/slide-42.svg)

The two calculations multiply the X matrix first by
[1, 0]ᵀ and then by [0, 1]ᵀ, showing
|0⟩ → |1⟩ → |0⟩. Each output is a definite
computational-basis state, making this the simplest
example of the matrix-vector rule.

The pair also establishes X² = I: X is its own inverse.
Unlike the H example, there is no intermediate equal
superposition for this input. The same calculation pattern
works for arbitrary amplitudes, where the two entries
are swapped without losing their phase information.

### Slide 43 / X gate: Bloch-sphere rotation

> **TL;DR:** X makes a 180° turn about the Bloch sphere's x axis.

![X gate: Bloch-sphere rotation](slides/slide-43.svg)

The input arrow points to the north pole and the output
to the south pole, matching |0⟩ → |1⟩.
A dashed x axis and a yellow half-turn trajectory
identify the rotation. The general coordinate mapping
is (x, y, z) → (x, −y, −z).

The x coordinate remains fixed while y and z reverse.
Thus the ±x directions are unchanged as physical states,
even though the poles exchange. The drawing describes
the gate up to global phase and projects a three-dimensional
path into the plane of the slide.

### Slide 44 / Y gate: circuit and unitary transformation

> **TL;DR:** Y flips the basis states with factors of i
> that must be retained in the amplitude calculation.

![Y gate: circuit and unitary transformation](slides/slide-44.svg)

The circuit labels |0⟩ → |1⟩ up to global phase.
The matrix, with rows (0, −i) and (i, 0), supplies
the exact rules: Y|0⟩ = i|1⟩ and
Y|1⟩ = −i|0⟩.

For the illustrated basis-state input, i is an overall
phase and does not change the measurement outcome.
For a general superposition, however, the different
factors on the two components affect their relative
phase. The slide therefore distinguishes the simplified
circuit labels from the full complex-valued transformation.

### Slide 45 / Y gate: unitary transformation

> **TL;DR:** Keeping the imaginary factors shows exactly
> why Y² = I.

![Y gate: unitary transformation](slides/slide-45.svg)

The worked sequence is |0⟩ → i|1⟩ → |0⟩.
The first multiplication gives [0, i]ᵀ rather than
silently replacing it with [0, 1]ᵀ. In the second,
the first entry becomes (−i)i = 1 and the second
becomes 0.

This makes the reversibility exact at the state-vector
level, not merely equivalent in measurement probabilities.
It also reinforces why complex arithmetic is part of
the model: phase factors that are invisible in a
single basis-state measurement still participate in
subsequent gate calculations.

### Slide 46 / Y gate: Bloch-sphere rotation

> **TL;DR:** Y is a 180° turn about y; the Bloch sphere
> does not display the output's global factor i.

![Y gate: Bloch-sphere rotation](slides/slide-46.svg)

The north-pole input moves to the south pole along
a half-turn about the y axis. The output is labeled
i|1⟩, consistent with the preceding multiplication,
and the coordinate rule is
(x, y, z) → (−x, y, −z).

X and Y both exchange the poles, but their different
axes give different actions on other directions.
The sphere cannot distinguish i|1⟩ from |1⟩
because they differ only by global phase. This is why
the geometric picture complements, rather than replaces,
the exact amplitude calculation.

### Slide 47 / Z gate: circuit and unitary transformation

> **TL;DR:** Z changes the sign of the |1⟩ component,
> turning |+⟩ into |−⟩.

![Z gate: circuit and unitary transformation](slides/slide-47.svg)

The circuit deliberately starts with |+⟩ so that
the phase flip is visible in the output label |−⟩.
The matrix has rows (1, 0) and (0, −1), and its
basis-state rules are Z|0⟩ = |0⟩ and
Z|1⟩ = −|1⟩.

Applied to α|0⟩ + β|1⟩, Z gives
α|0⟩ − β|1⟩. The immediate computational-basis
probabilities do not change, but the relative phase does.
That difference matters when a later operation combines
the components, as H does.

### Slide 48 / Z gate: unitary transformation

> **TL;DR:** Z flips the second amplitude's sign,
> and applying it twice restores the original column.

![Z gate: unitary transformation](slides/slide-48.svg)

The two explicit multiplications show
|+⟩ → |−⟩ → |+⟩. The input column
[1/√2, 1/√2]ᵀ becomes [1/√2, −1/√2]ᵀ,
then returns to its initial values under another Z.
All normalization factors remain inside the columns.

This demonstrates Z² = I while isolating a phase-only
change. Both intermediate states yield 50/50 outcomes
in the computational basis, so those probabilities
alone would conceal the transformation. The signed
amplitudes record the information needed to distinguish
the states under other measurements or gates.

### Slide 49 / Z gate: Bloch-sphere rotation

> **TL;DR:** Z makes a 180° turn about z, leaving
> the poles fixed and exchanging |+⟩ with |−⟩.

![Z gate: Bloch-sphere rotation](slides/slide-49.svg)

The white +x input vector rotates to a yellow
−x output, illustrating |+⟩ → |−⟩.
The dashed axis runs through the poles, and the
coordinate mapping is
(x, y, z) → (−x, −y, z).

Keeping z unchanged explains why computational-basis
probabilities are unchanged. The turn changes the
azimuthal direction, which represents relative phase.
It also clarifies why −|1⟩ remains at the same
south-pole point as |1⟩: for that basis state
alone the sign is only a global phase.

### Slide 50 / CNOT gate: circuit and unitary transformation

> **TL;DR:** CNOT flips the second qubit only when
> the first qubit is 1.

![CNOT gate: circuit and unitary transformation](slides/slide-50.svg)

A two-wire circuit uses the first qubit as the
control and the second as the target. The concrete
example is |10⟩ → |11⟩, with simple
|0⟩ and |1⟩ labels on the individual wires.
The 4×4 matrix fixes |00⟩ and |01⟩ while
exchanging |10⟩ and |11⟩.

In the ordered basis used throughout the deck,
the matrix rows are (1, 0, 0, 0),
(0, 1, 0, 0), (0, 0, 0, 1), and
(0, 0, 1, 0). A quantum control is not measured
to make a classical decision; the same operation
acts coherently on superpositions.

### Slide 51 / CNOT gate: unitary transformation

> **TL;DR:** CNOT exchanges the |10⟩ and |11⟩
> amplitude entries, and CNOT² = I.

![CNOT gate: unitary transformation](slides/slide-51.svg)

The worked columns show
|10⟩ = [0, 0, 1, 0]ᵀ mapping to
|11⟩ = [0, 0, 0, 1]ᵀ, then returning
under the same 4×4 matrix. This extends the
single-qubit multiplication examples to a joint state
without changing the calculation method.

For an arbitrary column [α, β, γ, δ]ᵀ,
the result is [α, β, δ, γ]ᵀ.
That row exchange preserves normalization and
reveals why the operation is its own inverse;
a footnote on the slide states that CNOT is unitary too.
Its linear action also applies when the input
contains several nonzero amplitudes.

### Slide 52 / CNOT gate: entangling two qubits

> **TL;DR:** H on the control, then CNOT, turns |00⟩ into
> the Bell state (|00⟩ + |11⟩)/√2.

![CNOT gate: entangling two qubits](slides/slide-52.svg)

Starting from |00⟩, H puts the control in |+⟩ and leaves the target
in |0⟩. The joint state is still a product:
|+⟩ ⊗ |0⟩ = (|00⟩ + |10⟩)/√2. CNOT maps |10⟩ to |11⟩ while
leaving |00⟩ unchanged. The result is a coherent superposition that
no longer factors into separate one-qubit states.

Measuring both qubits of this Bell state in the computational (Z)
basis gives 00 or 11 with probability ½ each. Matching bits alone
do not establish entanglement: a classical 50:50 mixture of 00 and
11 gives the same measurement statistics.

### Slide 53 / Bell state, part 1: H and tensor product

> **TL;DR:** H|0⟩ = |+⟩, and |+⟩ ⊗ |0⟩ is the joint column
> (1/√2, 0, 1/√2, 0)ᵀ.

![Bell state, part 1: H and tensor product](slides/slide-53.svg)

Slide 38 gives the Hadamard matrix; slide 39 works through its
multiplication. Here H acts on the control column (1, 0)ᵀ and
produces (1/√2, 1/√2)ᵀ = |+⟩. The target qubit is left
alone in |0⟩.

Step 2 uses the tensor-product rule from slide 35.
Multiplying each entry of |+⟩ by the whole target column
(1, 0)ᵀ gives (1/√2, 0, 1/√2, 0)ᵀ, which is
(|00⟩ + |10⟩)/√2 in the ordered basis |00⟩, |01⟩, |10⟩, |11⟩.
A footnote stresses that this is still a product state:
every joint entry is one amplitude from each qubit multiplied
together, so nothing is entangled yet.

### Slide 54 / Bell state, part 2: CNOT entangles

> **TL;DR:** CNOT swaps the last two rows, producing
> (1/√2, 0, 0, 1/√2)ᵀ = (|00⟩ + |11⟩)/√2, which is not a product state.

![Bell state, part 2: CNOT entangles](slides/slide-54.svg)

Step 3 applies the 4×4 CNOT transformation from slide 50 to the joint
column. Rows one and two are unchanged, while rows three and four
exchange places, so (1/√2, 0, 1/√2, 0)ᵀ becomes (1/√2, 0, 0, 1/√2)ᵀ.
That is the Bell state (|00⟩ + |11⟩)/√2.

Measuring both qubits in Z gives 00 and 11 with probability ½ each,
and never 01 or 10. A classical mixture could give the same counts.
It is the coherent state vector that cannot factor: a product state
(α, β)ᵀ ⊗ (γ, δ)ᵀ has entries
αγ, αδ, βγ, βδ; here αγ = βδ ≠ 0 while αδ = βγ = 0, which no
choice of single-qubit amplitudes can satisfy. Q# example 5 displays
the two nonzero amplitudes, each exactly 1/√2, rounded to 0.7071.

### Slide 55 / Quantum Code

> **TL;DR:** Chapter 5 translates the same states
> and gates into small Q# programs.

![Quantum Code](slides/slide-55.svg)

The final chapter divider asks **How is Q#
related to all of this?** The discussion now
moves from written calculations and circuits
to executable examples with simulator diagnostics.

The six examples progress from allocating
|0⟩ to an X flip, equal superposition,
unequal superposition, entanglement, and Shor's
factoring algorithm. The first five code slides
pair a syntax-highlighted program with an amplitude
table; the final example explains how quantum period
finding and classical post-processing recover factors.

### Slide 56 / Your first qubit in Q#

> **TL;DR:** Allocating a Q# qubit initializes it
> to |0⟩; simulator diagnostics can inspect that state.

![Your first qubit in Q#](slides/slide-56.svg)

The source in
[`examples/example-1/src/Main.qs`](examples/example-1/src/Main.qs)
uses `use q = Qubit();` and calls
`Std.Diagnostics.DumpMachine()`. The table shows
|0⟩ with amplitude 1.0000 + 0.0000i and
probability 100%; the zero-amplitude |1⟩
row is omitted. No gates are applied,
so the qubit remains in |0⟩ when released.

`DumpMachine()` inspects a local simulator's
state; it is not a measurement or a way to
read all amplitudes from real hardware.
As in VS Code diagnostics, the drawn tables list
only nonzero amplitudes, which a note on the slide
makes explicit; the Python runner uses a compact
`STATE:` format. Phase is displayed as zero for
positive-real amplitudes.

### Slide 57 / Flip a qubit with the X gate

> **TL;DR:** `X(q);` changes the new qubit
> from |0⟩ to |1⟩ before diagnostics run.

![Flip a qubit with the X gate](slides/slide-57.svg)

The source in
[`examples/example-2/src/Main.qs`](examples/example-2/src/Main.qs)
allocates a qubit, applies `X(q);`, calls
`DumpMachine()`, and then calls `Reset(q);`.
The displayed table therefore describes |1⟩,
not the reset state: the single row |1⟩ has
amplitude 1.0000 + 0.0000i and probability 100%.

This is the direct code counterpart of the
X matrix multiplication. Reset happens after
inspection so the qubit can be safely released
in |0⟩. Separating the state preparation,
diagnostics, and cleanup makes it clear which
point in the program the table represents.

### Slide 58 / Create a superposition with H

> **TL;DR:** `H(q);` prepares |+⟩ with
> two amplitudes of 1/√2 and two 50% probabilities.

![Create a superposition with H](slides/slide-58.svg)

The source in
[`examples/example-3/src/Main.qs`](examples/example-3/src/Main.qs)
applies H to a newly allocated qubit.
The simulator table shows both |0⟩ and
|1⟩ with amplitude 0.7071 + 0.0000i,
probability 50%, and phase 0. The displayed
amplitudes are rounded to four decimal places;
their exact value is 1/√2.

The table is a diagnostic view of a coherent
state, not a record of two simultaneous
measurement results. Repeated computational-basis
measurements of independently prepared copies
would approach a 50/50 distribution.
`DumpMachine()` runs before `Reset(q);`
returns the qubit to zero for release.

### Slide 59 / A 25% / 75% superposition with Ry

> **TL;DR:** A 120° Ry rotation prepares
> amplitudes 1/2 and √3/2, giving probabilities
> of 25% and 75%.

![A 25% / 75% superposition with Ry](slides/slide-59.svg)

The source in
[`examples/example-4/src/Main.qs`](examples/example-4/src/Main.qs)
starts in |0⟩ and applies
`Ry(2.0 * PI() / 3.0, q);`.
Using the half-angle relationships,
cos(60°) = 1/2 and sin(60°) = √3/2,
so the resulting state is
(1/2)|0⟩ + (√3/2)|1⟩.

The table displays amplitudes 0.5000 and
0.8660, probabilities 25% and 75%, and
zero phase for both. This demonstrates that
superpositions need not be equally weighted,
and that probabilities come from squared
amplitudes rather than the amplitudes themselves.
Ry gives real positive amplitudes for this
input and angle; diagnostics again precede reset.

### Slide 60 / Entangle two qubits with H and CNOT

> **TL;DR:** H on the first qubit followed
> by CNOT prepares (|00⟩ + |11⟩)/√2.

![Entangle two qubits with H and CNOT](slides/slide-60.svg)

The source in
[`examples/example-5/src/Main.qs`](examples/example-5/src/Main.qs)
allocates two qubits in |00⟩. H on
the first prepares (|00⟩ + |10⟩)/√2;
CNOT then maps the |10⟩ component
to |11⟩, creating a Bell state.
The table lists the two nonzero basis states:
|00⟩ and |11⟩ each have amplitude
1/√2 (displayed as 0.7071) and probability 50%; |01⟩
and |10⟩ have zero amplitude and are omitted.

Measuring both qubits in the computational (Z) basis would give 00 or 11.
A classical 50:50 mixture gives the same counts; what distinguishes the
prepared Bell state is its coherent, nonfactorable amplitude column.
`DumpMachine()` inspects that column before `ResetAll(qs);`. The table
is not a measurement log.

### Slide 61 / Example 6: Shor's algorithm in Q#

> **TL;DR:** Worked input: 143 = 11 × 13. Shor's algorithm
> can use quantum period finding and classical GCDs to find those factors.

![Example 6: Shor's algorithm in Q#](slides/slide-61.svg)

The source in
[`examples/example-6/src/shor.qs`](examples/example-6/src/shor.qs)
first chooses a random base and
checks whether a greatest common divisor already
reveals a factor. Otherwise, semiclassical phase
estimation and controlled modular multiplication
estimate the base's period modulo 143.

Continued fractions give a candidate period `r`, which may be only a divisor
of the true order. For even `r`, the algorithm tests `gcd(a^(r/2) ± 1, 143)`.
If the candidate is odd or gives only trivial factors, it retries.

The shipped `run.py` calls `Sample.Main()`, whose default input is **999997**.
To reproduce the slide without running that default, execute this Python code
from the repository root with the example's QDK dependency installed:

```python
from qdk import qsharp

qsharp.init(project_root="examples/example-6")
print(qsharp.eval("Sample.FactorSemiprimeInteger(143)"))
```

The factors are 11 and 13, in either order.

### Slide 62 / Thank you and questions

> **TL;DR:** Gates transform a pure-state vector. In the chosen measurement
> basis, outcome k has probability |aₖ|².

![Thank you and questions](slides/slide-62.svg)

A unitary gate preserves normalization but can redistribute amplitudes.
To predict a measurement, express the state in the chosen basis and
square the magnitude of each coefficient. Outcomes need not be equally
likely: measuring |0⟩ in the computational basis gives 0 with certainty.
Algorithms use interference to increase the probability of useful outcomes.

The QR code links to [this CloudBrew repository](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026).
Choose **Open SVG** in the offline preview to use the embedded link.
