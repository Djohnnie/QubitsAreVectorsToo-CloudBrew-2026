# Qubits Are Vectors Too

**The Math Behind Quantum Computing / CloudBrew 2026**

A qubit is not just a mysterious alternative to a bit: its state can be
described by a normalized vector, and quantum gates act on that vector through
matrix multiplication. **Qubits Are Vectors Too** introduces the mathematics
behind quantum computing for a developer audience, connecting physical
intuition, complex amplitudes, linear algebra, quantum circuits, and Q#.

The 61-slide presentation follows five chapters. **Introduction** explores
motivation, quantum phenomena, and hardware. **Quantum Math** introduces basis
states, superposition, normalization, and complex numbers. **Vectors** connects
those ideas to column vectors, the Bloch sphere, and tensor products.
**Quantum Logic** explains gates through circuits, worked matrix
multiplications, and geometric rotations. **Quantum Code** brings the same
states and operations to life in six Q# examples.

Open the [offline slide preview](_slides/index.html) to navigate the deck with
the arrow keys, or browse the individual slides below. Each slide has its own
TL;DR box and a detailed explanation of its content and place in the story.
The runnable Q# examples linked below for slides 55–60 are hosted in the
[original presentation repository](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026)
and use a local simulator; no Azure account or quantum hardware is required.
This CloudBrew repository includes the deck and the first five presentation
snippets in `_resources/code`.

## Presentation slides

### Slide 1 / Qubits Are Vectors Too

> **TL;DR:** Quantum computing becomes more approachable when qubits are vectors
> and gates are transformations.

![Qubits Are Vectors Too](_slides/slide-01.svg)

The opening slide introduces the session, its subtitle **The Math Behind
Quantum Computing**, and presenter Johnny Hooyberghs at
[CloudBrew 2026](https://www.cloudbrew.be/) in Mechelen, Belgium.
The enlarged conference logo sits opposite the title, establishing
the event and the deck's navy, blue, and yellow visual identity.
Montserrat headings, Open Sans body text, and a subtle cloud background
carry the conference website's theme throughout the deck.

The title states the talk's central idea: familiar linear-algebra tools can
explain quantum states and their evolution. The emphasis is on developer
intuition grounded in mathematics, rather than treating quantum computing as
an opaque collection of physical effects.

### Slide 2 / Johnny Hooyberghs

> **TL;DR:** The speaker approaches quantum computing from a software
> developer's perspective.

![Johnny Hooyberghs](_slides/slide-02.svg)

A speaker portrait accompanies an introduction covering .NET custom application
development, Azure Cloud, and GenAI. The slide lists 18 years of professional
experience, an interest in quantum computing, public speaking and training,
and Microsoft MVP recognition in Developer Technologies and Microsoft Azure
since 2020.

A muted silhouette of Belgium sits behind the text, with a dark blue fill
and a restrained border to indicate the speaker's home country without
competing with the portrait or biography. The embedded map is adapted from
the [user-supplied Pixabay image](https://cdn.pixabay.com/photo/2016/10/21/19/03/belgium-1758814_1280.png),
stored in `_resources/belgium.png`.

This background positions the session as a bridge from everyday software
engineering to quantum concepts. The audience is invited to use its existing
technical reasoning skills while learning the mathematical model.

### Slide 3 / Scan to visit the repository

> **TL;DR:** The QR code leads to the original slides, explanations, and
> shared Q# examples.

![Scan to visit the repository](_slides/slide-03.svg)

A large, centered QR code gives the audience a direct route to the
[original presentation repository](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026).
The code is also a clickable link in the SVG, making the same slide useful
both in the room and when viewed on a computer. The CloudBrew adaptation
retains that QR destination; its themed slides and explanations are collected
in [this repository](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026).

Its purpose is to let attendees follow along or revisit the equations and
examples afterward. The uncluttered layout makes access to the material the
only message before the talk moves into its roadmap.

### Slide 4 / Agenda

> **TL;DR:** The journey runs from quantum motivation to mathematics, vectors,
> gates, and working Q# code.

![Agenda](_slides/slide-04.svg)

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

![Introduction](_slides/slide-05.svg)

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

![Paper folding to the Moon: question](_slides/slide-06.svg)

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

![Paper folding to the Moon: answer](_slides/slide-07.svg)

The same composition now reveals the answer **42**: 42 folds, shown without
an exclamation mark so it cannot be misread as a factorial. The completed
calculation is 0.1 mm × 2⁴² ≈ 439,805 km, exceeding
the average distance of 384,400 km. For comparison, 41 doublings reach only
about 219,902 km, so the threshold is crossed at 42.

Keeping the illustration unchanged makes the numerical reveal the focus.
The lesson is the scale of repeated doubling, not a claim that paper can
actually be folded this way. Later, every additional qubit similarly doubles
the number of amplitudes in a general pure-state description.

### Slide 8 / Molecular chemistry & DNA

> **TL;DR:** Molecular systems motivate computing methods that can represent
> quantum behavior directly.

![Molecular chemistry and DNA](_slides/slide-08.svg)

Molecular structures, chemical bonds, a DNA double helix, and a laboratory
flask introduce chemistry as a real-world problem domain. The illustration
shifts the talk from an abstract growth puzzle to systems whose properties
depend on microscopic physical interactions.

The connection is that molecules themselves obey quantum mechanics, making
their simulation a natural motivation for quantum computing. The slide
introduces the domain rather than a particular algorithm or a demonstrated
speedup; it should not be read as a promise that every chemistry or DNA
problem is immediately solvable on current hardware.

### Slide 9 / Global logistics & supply chains

> **TL;DR:** Logistics illustrates how many interacting choices can create
> a difficult optimization problem.

![Global logistics and supply chains](_slides/slide-09.svg)

An aircraft, globe, delivery routes, cargo truck, shipping crates, and a
checklist depict a network of connected decisions. Routing, scheduling,
capacity, and delivery requirements affect one another, so improving one
part of a supply chain can change the constraints elsewhere.

This is a motivation slide for combinatorial optimization: the number of
candidate plans can grow rapidly as choices are added. Quantum approaches
are an area of investigation for such problems, but a large search space
alone does not establish a quantum advantage. No specific logistics algorithm
or performance result is claimed here.

### Slide 10 / Cryptography & security

> **TL;DR:** Quantum computing changes some of the computational assumptions
> on which security depends.

![Cryptography and security](_slides/slide-10.svg)

A central padlock, keys, binary digits, and circuit traces introduce security
as the third application domain. Unlike the chemistry and logistics images,
this picture emphasizes protecting information and the mathematical
difficulty that underlies cryptographic systems.

The topic motivates why developers should understand quantum computing even
if they never program a quantum device. Some public-key schemes would be
threatened by sufficiently capable, fault-tolerant quantum computers; this
is not a statement that current machines can break all encryption.
The slide is a thematic introduction, not a cryptographic attack walkthrough.

### Slide 11 / Electron spin

> **TL;DR:** Spin provides a physical example of two basis states and
> their superposition.

![Electron spin](_slides/slide-11.svg)

Arrows and electron symbols illustrate spin-up and spin-down states alongside
a schematic superposition, each labeled beneath the symbol. Plus and
equality signs suggest that the description can combine the two basis states
rather than choosing only one. This prepares the audience for the later
expression α|0⟩ + β|1⟩.

A footnote on the slide states that the arrows mark a spin state along a
chosen measurement axis and that an electron is not literally spinning like
a ball.
Likewise, superposition is a state description with amplitudes, not an
observation of both measurement results at once. Measurement along that
axis yields one of the allowed outcomes.

### Slide 12 / Schrödinger's cat

> **TL;DR:** The cat thought experiment highlights the tension between
> quantum superposition and definite observed outcomes.

![Schrödinger's cat](_slides/slide-12.svg)

Side-by-side illustrations show the alive and dead outcomes, each with a box
and experimental apparatus. The familiar thought experiment connects a
microscopic quantum event to a macroscopic consequence, making the question
of measurement tangible.

The two pictures are alternatives used to discuss the experiment, not a
literal account of an ordinary cat simultaneously displaying two observable
conditions. The slide opens the conceptual question of how a quantum state
relates to what we see; the later mathematical chapters describe states and
measurement probabilities without requiring a choice of interpretation.

### Slide 13 / Entangled electrons

> **TL;DR:** Entangled particles must be described jointly because their
> measurement outcomes are correlated.

![Entangled electrons](_slides/slide-13.svg)

Two electrons with matching spin outcomes are joined by an infinity-shaped
link. The link is a visual shorthand for their correlations, not a physical
wire or a signal passing between them. A footnote ties the picture to the
Bell state built in the final Q# example, where both measurements agree.

The important shift is from describing each particle independently to
describing a shared quantum state. Neither individual outcome needs to be
predictable for the relationship between outcomes to be constrained.
Entanglement does not provide controllable faster-than-light communication.

### Slide 14 / A Feynman quote

> **TL;DR:** Quantum mechanics challenges everyday intuition; a precise
> mathematical model is more useful than forced classical analogies.

![A Feynman quote](_slides/slide-14.svg)

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

![A quantum computer](_slides/slide-15.svg)

A full-slide photograph shows a suspended cryogenic assembly, with the
section label, slide title, and branding overlaid on dark fades. Slides 15–19
all carry a visible title so the hardware survey reads consistently. Its visible layers and connections
make the scale and complexity of the physical apparatus the main subject.

The photograph grounds the preceding concepts in engineering. In platforms
that require cryogenic operation, cooling and control infrastructure create
the conditions in which qubits can function. The image should not be taken
as a universal design: the next slides show that quantum computing has
multiple hardware approaches with different requirements.

### Slide 16 / Vacuum tube computing

> **TL;DR:** Early classical hardware is a reminder that computing platforms
> evolve dramatically over time.

![Vacuum tube computing](_slides/slide-16.svg)

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

> **TL;DR:** Physical qubits need carefully engineered devices, connections,
> and operating conditions.

![Superconducting qubits](_slides/slide-17.svg)

The source photograph associated with superconducting qubits shows a close-up
of cryogenic hardware and its connections. Rather than supplying a microscopic
device diagram, it emphasizes the surrounding apparatus needed to interact
with a quantum system.

The slide introduces one hardware topic in a broader survey, not a detailed
explanation of a particular qubit design. Its connection to the talk is the
separation between implementation and abstraction: however a qubit is
physically realized, the following chapters will describe its idealized
state with the same amplitude and vector language.

### Slide 18 / Neutral atom qubits

> **TL;DR:** Neutral atoms offer another physical platform for representing
> and controlling qubits.

![Neutral atom qubits](_slides/slide-18.svg)

The photograph shows the Pasqal ORION neutral-atom quantum computing
apparatus. The named system gives the hardware survey a concrete example
beyond the cryogenic assembly imagery.

Neutral-atom platforms use controlled atomic states as quantum information
carriers, with optical techniques playing a central role in their manipulation.
The photograph introduces the apparatus rather than specifying its gate set,
qubit count, or performance. The broader point is that the mathematical
ideas in the talk are not tied to a single manufacturer's machine or a
single physical technology.

### Slide 19 / Topological qubits & Majorana quasiparticles

> **TL;DR:** Topological approaches investigate different ways to encode and
> protect quantum information.

![Topological qubits and Majorana quasiparticles](_slides/slide-19.svg)

Microsoft Majorana hardware illustrates the final topic in the hardware
survey. The photograph and title introduce topological qubits and Majorana
quasiparticles as another direction in quantum-device research.

The motivation for topological encoding is to make information less vulnerable
to certain local disturbances. This slide does not establish that a photograph
demonstrates fault tolerance, scalable operation, or any particular experimental
milestone. It closes the survey by showing the diversity of hardware ideas
before the talk turns to the shared mathematical representation of qubits.

### Slide 20 / Quantum Math

> **TL;DR:** Chapter 2 replaces loose analogies with amplitudes and the rules
> they must satisfy.

![Quantum Math](_slides/slide-20.svg)

The second chapter divider asks **Is math important in quantum?** Its large
chapter number signals a change from motivation and physical examples to
the language needed to calculate quantum behavior.

The next sequence builds the model one step at a time: classical values,
quantum basis states, superposition, normalization, complex amplitudes,
and multi-qubit expansions. Each addition answers a specific question
about what information a quantum-state description must contain.

### Slide 21 / Classical bits

> **TL;DR:** A classical bit has one of two values: 0 or 1.

![Classical bits](_slides/slide-21.svg)

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

![Quantum bits or qubits](_slides/slide-22.svg)

The classical numerals are replaced by the kets |0⟩ and |1⟩. The surrounding
symbols are meaningful: a ket names a state vector, rather than merely
decorating the classical digit.

These two states form the computational basis used throughout the talk.
A computational-basis measurement of a qubit prepared in |0⟩ returns 0
with certainty, and one prepared in |1⟩ returns 1 with certainty.
They are the building blocks for more general states, not the complete
list of pure states a qubit can occupy.

### Slide 23 / Qubits in superposition

> **TL;DR:** A general pure qubit state combines the basis states as
> α|0⟩ + β|1⟩.

![Qubits in superposition](_slides/slide-23.svg)

A large expression α|0⟩ + β|1⟩ introduces superposition, with the amplitudes
highlighted in the deck's yellow-to-pale-yellow gradient. The basis states remain
fixed while their coefficients specify the particular state.

The coefficients are probability amplitudes, not probabilities themselves.
Their magnitudes and relative phase determine measurement statistics and
how later gates interfere the components. This distinction is the key
reason that a superposition is not simply a classical random choice
between 0 and 1.

### Slide 24 / Normalized qubit amplitudes

> **TL;DR:** The squared magnitudes of a qubit's amplitudes must sum to one.

![Normalized qubit amplitudes](_slides/slide-24.svg)

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

![Complex qubit amplitudes](_slides/slide-25.svg)

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

![Two qubits: four amplitudes](_slides/slide-26.svg)

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

![More qubits, exponentially more amplitudes](_slides/slide-27.svg)

Explicit expansions for two, three, and four qubits show four, eight,
and sixteen amplitudes respectively. The coefficients are written as an
indexed family α₀ … α₁₅ so that the notation scales; each
computational-basis state appears once in binary order, and the four-qubit
expression wraps across two lines so that the doubling remains readable.

This returns to the paper-folding intuition: adding one qubit doubles
the dimension of the state space. It helps explain why storing a general
state vector on a classical simulator becomes expensive. It does not mean
that measurement exposes all 2ⁿ amplitudes at once or that quantum
computers automatically solve every exponential problem efficiently.

### Slide 28 / Vectors

> **TL;DR:** Chapter 3 makes the amplitude model concrete with vectors
> and geometry.

![Vectors](_slides/slide-28.svg)

The chapter divider asks **What about vectors and linear algebra?**
It marks the transition from ket expansions to alternative representations
of the same states.

The chapter introduces the Bloch sphere, works through |0⟩, |1⟩,
and |+⟩, relates amplitudes to angles, and then extends column vectors
to two-qubit systems. Tensor products explain how independent state
columns combine, supplying the notation needed for the gate matrices
in the next chapter.

### Slide 29 / The Bloch sphere

> **TL;DR:** The Bloch sphere represents a single pure qubit state as
> a direction in three-dimensional space.

![The Bloch sphere](_slides/slide-29.svg)

Two wireframe Bloch spheres appear side by side. One establishes the
coordinate system with z pointing up, x to the right, and y toward the
viewer at the lower left, the same orientation used on every later Bloch
sphere in the deck; the other adds a highlighted
state direction |φ⟩. Solid and dashed curves distinguish the visible
and hidden parts of the spherical grid.

The north and south poles correspond to |0⟩ and |1⟩. Other surface
directions represent superpositions, with polar and azimuthal angles
encoding amplitude balance and relative phase. Global phase is omitted,
so this is a representation of the physical pure state, not a literal
plot of two complex amplitude entries or of an electron's trajectory.

### Slide 30 / Ket zero

> **TL;DR:** |0⟩ is the column vector [1, 0]ᵀ and sits at the Bloch
> sphere's north pole.

![Ket zero](_slides/slide-30.svg)

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

![Ket one](_slides/slide-31.svg)

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

![A perfect 50/50 superposition](_slides/slide-32.svg)

The state |+⟩ = (|0⟩ + |1⟩)/√2 has α = β = 1/√2.
Its column vector contains those two entries, and the normalization
calculation gives 1/2 + 1/2 = 1. Measurement in the computational
basis produces either outcome with 50% probability.

The Bloch-circle arrow points along positive x, with θ = 90°.
The word **positive** matters: equal probabilities alone do not
uniquely specify a state. The state |−⟩ has the same probabilities
but a different relative sign, a distinction later demonstrated
by the Z gate.

### Slide 33 / From amplitudes to Bloch angles

> **TL;DR:** For real, nonnegative amplitudes, α = cos(θ/2) and
> β = sin(θ/2).

![From amplitudes to Bloch angles](_slides/slide-33.svg)

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

![Two qubits and the joint state](_slides/slide-34.svg)

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

![Tensor product of two state columns](_slides/slide-35.svg)

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

### Slide 36 / Quantum Logic

> **TL;DR:** Chapter 4 describes quantum gates as consistent transformations
> of state vectors.

![Quantum Logic](_slides/slide-36.svg)

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

### Slide 37 / H gate: circuit and matrix

> **TL;DR:** Hadamard maps the computational basis to equal superpositions:
> |0⟩ → |+⟩ and |1⟩ → |−⟩.

![H gate: circuit and matrix](_slides/slide-37.svg)

A single circuit wire carries |0⟩ through an H box to |+⟩.
Below it, the Hadamard matrix has rows (1/√2, 1/√2)
and (1/√2, −1/√2), with each normalization factor written
inside the matrix. The action on both basis states is stated
beside the matrix.

The negative entry distinguishes |−⟩ = (|0⟩ − |1⟩)/√2
from |+⟩. H is not merely a source of random bits: it
changes basis coherently, retaining the phase information
needed to reverse the transformation.

### Slide 38 / H gate: matrix multiplication

> **TL;DR:** Applying H twice returns the original state because
> H² = I.

![H gate: matrix multiplication](_slides/slide-38.svg)

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

### Slide 39 / H gate: Bloch-sphere rotation

> **TL;DR:** H is a 180° Bloch rotation about the diagonal
> axis (x + z)/√2.

![H gate: Bloch-sphere rotation](_slides/slide-39.svg)

A white input vector at +z rotates to a yellow output at +x,
visualizing |0⟩ → |+⟩. The yellow trajectory shows
the rotation path, while a dashed blue line marks the
diagonal rotation axis. The coordinate rule is
(x, y, z) → (z, −y, x).

The axis stays fixed and the x and z directions exchange
roles. The sphere omits global phase, so this geometric
description is stated up to global phase. The curve is a
two-dimensional projection of a three-dimensional surface
path; appearing inside the drawn circle does not mean
the state has become mixed.

### Slide 40 / X gate: circuit and matrix

> **TL;DR:** X is the quantum bit flip: it swaps |0⟩ and |1⟩.

![X gate: circuit and matrix](_slides/slide-40.svg)

The circuit passes |0⟩ through an X box and labels the
output |1⟩. The matrix has rows (0, 1) and (1, 0),
with the two basis-state rules X|0⟩ = |1⟩ and
X|1⟩ = |0⟩ shown explicitly.

For a general state α|0⟩ + β|1⟩, multiplying by
this matrix gives β|0⟩ + α|1⟩. It exchanges the
amplitudes themselves, including any complex values,
rather than measuring the state and conditionally
changing a classical result.

### Slide 41 / X gate: matrix multiplication

> **TL;DR:** X exchanges the two entries of the state column,
> and a second X exchanges them back.

![X gate: matrix multiplication](_slides/slide-41.svg)

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

### Slide 42 / X gate: Bloch-sphere rotation

> **TL;DR:** X makes a 180° turn about the Bloch sphere's x axis.

![X gate: Bloch-sphere rotation](_slides/slide-42.svg)

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

### Slide 43 / Y gate: circuit and matrix

> **TL;DR:** Y flips the basis states with factors of i
> that must be retained in the amplitude calculation.

![Y gate: circuit and matrix](_slides/slide-43.svg)

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

### Slide 44 / Y gate: matrix multiplication

> **TL;DR:** Keeping the imaginary factors shows exactly
> why Y² = I.

![Y gate: matrix multiplication](_slides/slide-44.svg)

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

### Slide 45 / Y gate: Bloch-sphere rotation

> **TL;DR:** Y is a 180° turn about y; the Bloch sphere
> does not display the output's global factor i.

![Y gate: Bloch-sphere rotation](_slides/slide-45.svg)

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

### Slide 46 / Z gate: circuit and matrix

> **TL;DR:** Z changes the sign of the |1⟩ component,
> turning |+⟩ into |−⟩.

![Z gate: circuit and matrix](_slides/slide-46.svg)

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

### Slide 47 / Z gate: matrix multiplication

> **TL;DR:** Z flips the second amplitude's sign,
> and applying it twice restores the original column.

![Z gate: matrix multiplication](_slides/slide-47.svg)

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

### Slide 48 / Z gate: Bloch-sphere rotation

> **TL;DR:** Z makes a 180° turn about z, leaving
> the poles fixed and exchanging |+⟩ with |−⟩.

![Z gate: Bloch-sphere rotation](_slides/slide-48.svg)

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

### Slide 49 / CNOT gate: circuit and matrix

> **TL;DR:** CNOT flips the second qubit only when
> the first qubit is 1.

![CNOT gate: circuit and matrix](_slides/slide-49.svg)

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

### Slide 50 / CNOT gate: matrix multiplication

> **TL;DR:** CNOT exchanges the |10⟩ and |11⟩
> amplitude entries, and CNOT² = I.

![CNOT gate: matrix multiplication](_slides/slide-50.svg)

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

### Slide 51 / CNOT gate: entangling two qubits

> **TL;DR:** H on the control, then CNOT, turns |00⟩ into
> the Bell state (|00⟩ + |11⟩)/√2.

![CNOT gate: entangling two qubits](_slides/slide-51.svg)

The circuit uses the same two-wire style as slide 49:
both qubits start in |0⟩, a Hadamard box sits on the
control wire, and CNOT follows with the familiar dot and
⊕ symbols. A brace joins the two output wires to a single
joint state, because the result can no longer be written
one wire at a time.

Three panels trace the state. The start is
|00⟩ = |0⟩ ⊗ |0⟩. After H the control is in
superposition, giving (|00⟩ + |10⟩)/√2 = |+⟩ ⊗ |0⟩.
CNOT flips the target only in the control-1 branch, which
turns |10⟩ into |11⟩ and leaves (|00⟩ + |11⟩)/√2. Only 00 and
11 remain, so measuring either qubit fixes the other. The next
two slides carry out this same sequence with explicit columns.

### Slide 52 / Bell state, part 1: H and tensor product

> **TL;DR:** H|0⟩ = |+⟩, and |+⟩ ⊗ |0⟩ is the joint column
> (1/√2, 0, 1/√2, 0)ᵀ.

![Bell state, part 1: H and tensor product](_slides/slide-52.svg)

Step 1 is a single-qubit calculation from slide 38:
the Hadamard matrix multiplies the column (1, 0)ᵀ and
produces (1/√2, 1/√2)ᵀ = |+⟩. The target qubit is left
alone in |0⟩.

Step 2 uses the tensor-product rule from slide 35.
Multiplying each entry of |+⟩ by the whole target column
(1, 0)ᵀ gives (1/√2, 0, 1/√2, 0)ᵀ, which is
(|00⟩ + |10⟩)/√2 in the ordered basis |00⟩, |01⟩, |10⟩, |11⟩.
A footnote stresses that this is still a product state:
every joint entry is one amplitude from each qubit multiplied
together, so nothing is entangled yet.

### Slide 53 / Bell state, part 2: CNOT entangles

> **TL;DR:** CNOT swaps the last two rows, producing
> (1/√2, 0, 0, 1/√2)ᵀ = (|00⟩ + |11⟩)/√2, which is not a product state.

![Bell state, part 2: CNOT entangles](_slides/slide-53.svg)

Step 3 applies the 4×4 CNOT matrix from slide 49 to the joint
column. Rows one and two are unchanged, while rows three and four
exchange places, so (1/√2, 0, 1/√2, 0)ᵀ becomes (1/√2, 0, 0, 1/√2)ᵀ.
That is the Bell state (|00⟩ + |11⟩)/√2.

A measurement panel reads off the probabilities: 00 and 11 each
occur 50% of the time, 01 and 10 never, so the two outcomes
always agree. A second panel shows why no tensor product can
produce this column. A product state (α, β)ᵀ ⊗ (γ, δ)ᵀ has entries
αγ, αδ, βγ, βδ; here αγ = βδ ≠ 0 while αδ = βγ = 0, which no
choice of single-qubit amplitudes can satisfy. The footnote
points ahead to Q# example 5, whose simulator output lists exactly
these two amplitudes of 0.7071.

### Slide 54 / Quantum Code

> **TL;DR:** Chapter 5 translates the same states
> and gates into small Q# programs.

![Quantum Code](_slides/slide-54.svg)

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

### Slide 55 / Your first qubit in Q#

> **TL;DR:** Allocating a Q# qubit initializes it
> to |0⟩; simulator diagnostics can inspect that state.

![Your first qubit in Q#](_slides/slide-55.svg)

The source in
[`example-1\src\Main.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-1/src/Main.qs)
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

### Slide 56 / Flip a qubit with the X gate

> **TL;DR:** `X(q);` changes the new qubit
> from |0⟩ to |1⟩ before diagnostics run.

![Flip a qubit with the X gate](_slides/slide-56.svg)

The source in
[`example-2\src\Main.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-2/src/Main.qs)
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

### Slide 57 / Create a superposition with H

> **TL;DR:** `H(q);` prepares |+⟩ with
> two amplitudes of 1/√2 and two 50% probabilities.

![Create a superposition with H](_slides/slide-57.svg)

The source in
[`example-3\src\Main.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-3/src/Main.qs)
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

### Slide 58 / A 25% / 75% superposition with Ry

> **TL;DR:** A 120° Ry rotation prepares
> amplitudes 1/2 and √3/2, giving probabilities
> of 25% and 75%.

![A 25% / 75% superposition with Ry](_slides/slide-58.svg)

The source in
[`example-4\src\Main.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-4/src/Main.qs)
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

### Slide 59 / Entangle two qubits with H and CNOT

> **TL;DR:** H on the first qubit followed
> by CNOT prepares (|00⟩ + |11⟩)/√2.

![Entangle two qubits with H and CNOT](_slides/slide-59.svg)

The source in
[`example-5\src\Main.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-5/src/Main.qs)
allocates two qubits in |00⟩. H on
the first prepares (|00⟩ + |10⟩)/√2;
CNOT then maps the |10⟩ component
to |11⟩, creating a Bell state.
The table lists the two nonzero basis states:
|00⟩ and |11⟩ each have amplitude
0.7071 and probability 50%; |01⟩
and |10⟩ have zero amplitude and are omitted.

Computational-basis measurements of the pair
therefore agree: the outcome is 00 or 11.
Unlike |++⟩, this joint state cannot
be factored into two pure single-qubit
states. The program inspects it with
`DumpMachine()` before `ResetAll(qs);`;
the displayed table is not a measurement log.

### Slide 60 / Example 6: Shor's algorithm in Q#

> **TL;DR:** Quantum period finding plus
> classical continued fractions and GCDs can
> factor a small semiprime.

![Example 6: Shor's algorithm in Q#](_slides/slide-60.svg)

The source in
[`example-6\src\shor.qs`](https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026/blob/main/example-6/src/shor.qs)
implements Shor's algorithm for the example
input 143. It first chooses a random base and
checks whether a greatest common divisor already
reveals a factor. Otherwise, semiclassical phase
estimation and controlled modular multiplication
estimate the base's period modulo 143.

The classical continued-fractions step recovers
a candidate period. When that period is even and
not a trivial case, GCDs of the half-period
powers offset by one yield non-trivial factors;
unsuitable attempts are retried. The result is
11 × 13. This is an educational demonstration
with a tiny input, not a practical cryptographic
factoring demonstration.

### Slide 61 / Thank you and questions

> **TL;DR:** Qubits are vectors, gates are
> unitary transformations, and measurements produce
> outcomes governed by the state's amplitudes.

![Thank you and questions](_slides/slide-61.svg)

The closing slide invites questions, repeats
the repository QR code, and places a colorful
Bloch sphere beside the final takeaways.
It reconnects the code examples to the
talk's central abstractions: vector states,
unitary transformations, and measurement.

The closing lines state that measurement picks
one basis state at random and that algorithms
make the desired outcome likely. An algorithm
prepares amplitudes so useful results are probable;
measurement yields an allowed outcome according
to its probability and updates the state
accordingly, so this is not a guarantee that
measurement selects whichever result we want.
