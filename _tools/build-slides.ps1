[CmdletBinding()]
param(
    [int[]]$OnlySlides
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$slides = Join-Path $root '_slides'
$resources = Join-Path $root '_resources'

function DataUri([string]$path, [string]$mime) {
    "data:$mime;base64,$([Convert]::ToBase64String([IO.File]::ReadAllBytes($path)))"
}

$regular = DataUri (Join-Path $resources 'fonts\OpenSans-Regular.ttf') 'font/ttf'
$bold = DataUri (Join-Path $resources 'fonts\OpenSans-Bold.ttf') 'font/ttf'
$heading = DataUri (Join-Path $resources 'fonts\Montserrat-Bold.ttf') 'font/ttf'
$math = DataUri (Join-Path $resources 'fonts\STIXTwoMath-Regular.ttf') 'font/ttf'
$logo = DataUri (Join-Path $resources 'cloudbrew-wordmark.png') 'image/png'
$cloud = DataUri (Join-Path $resources 'cloudbrew-cloud.png') 'image/png'
$cloudbrewIcon = DataUri (Join-Path $resources 'cloudbrew-logo.svg') 'image/svg+xml'
$speakerPhoto = DataUri (Join-Path $resources 'speaker-photo.jpg') 'image/jpeg'
$belgiumMap = DataUri (Join-Path $resources 'belgium.png') 'image/png'
$qrCode = DataUri (Join-Path $resources 'qrcode.svg') 'image/svg+xml'
$zureSvg = [IO.File]::ReadAllText((Join-Path $resources 'zure.svg')).Replace('currentColor', '#ffffff')
$zureLogo = "data:image/svg+xml;base64,$([Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($zureSvg)))"
$defs = @"
<defs>
  <clipPath id="speaker-photo-clip"><circle cx="360" cy="560" r="215"/></clipPath>
  <style>
    @font-face{font-family:'Open Sans';font-weight:400;src:url('$regular') format('truetype')}
    @font-face{font-family:'Open Sans';font-weight:700;src:url('$bold') format('truetype')}
    @font-face{font-family:Montserrat;font-weight:700;src:url('$heading') format('truetype')}
    @font-face{font-family:'STIX Two Math';font-weight:400;src:url('$math') format('truetype')}
    text{font-family:'Open Sans',sans-serif;fill:#e2e7f4}
    .heading{font-family:Montserrat,sans-serif;font-weight:700;fill:#ffffff;letter-spacing:-2px}
    .label{font-size:20px;letter-spacing:3px;font-weight:700;fill:#e7d450}
    .math{font-family:'STIX Two Math','Cambria Math',serif;fill:#ffffff}
  </style>
  <linearGradient id="accent" x1="0" y1="1" x2="1" y2="0">
    <stop stop-color="#e7d450"/><stop offset="1" stop-color="#f6f0c0"/>
  </linearGradient>
  <radialGradient id="glow">
    <stop stop-color="#133add" stop-opacity=".3"/><stop offset="1" stop-color="#133add" stop-opacity="0"/>
  </radialGradient>
  <pattern id="grid" width="60" height="60" patternUnits="userSpaceOnUse">
    <path d="M 60 0 L 0 0 0 60" fill="none" stroke="#304580" stroke-width="1" opacity=".25"/>
  </pattern>
  <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="9" markerHeight="9" orient="auto-start-reverse">
    <path d="M 0 0 L 10 5 L 0 10 Z" fill="#e7d450"/>
  </marker>
</defs>
"@

function Text([int]$x, [int]$y, [string]$value, [int]$size = 32, [string]$class = '') {
    '<text x="{0}" y="{1}" font-size="{2}" class="{3}">{4}</text>' -f $x, $y, $size, $class, [Security.SecurityElement]::Escape($value)
}

function Ket([int]$x, [int]$y, [string]$value, [int]$size) {
    $scale = $size / 100
    $safeValue = [Security.SecurityElement]::Escape($value)
    # Center STIX Two Math numeral ink within the vector brackets.
    $digitY = if ($value -eq '1') { -2.5 } else { -3 }
    @"
<g class="ket" transform="translate($x $y) scale($scale)">
  <path d="M-58 -85V15 M30 -85L58 -35L30 15" fill="none" stroke="#ffffff" stroke-width="4" stroke-linecap="round"/>
  <text x="-8.25" y="$digitY" text-anchor="middle" class="math" font-size="100">$safeValue</text>
</g>
"@
}

function Lines([int]$x, [int]$y, [string[]]$values, [int]$size = 32, [int]$gap = 52, [string]$class = '') {
    for ($i = 0; $i -lt $values.Count; $i++) {
        Text $x ($y + $i * $gap) $values[$i] $size $class
    }
}

function Panel([int]$x, [int]$y, [int]$w, [int]$h) {
    "<rect x='$x' y='$y' width='$w' height='$h' rx='16' fill='#091b68' stroke='#304580'/>"
}

function ColumnVector([int]$x, [int]$y, [string]$top, [string]$bottom, [int]$width = 110, [int]$size = 64) {
    $rightInset = $width - 20
    $center = $width / 2
    @"
<g transform="translate($x $y)">
  <path d="M20 0H0V180H20 M$rightInset 0H${width}V180H$rightInset" fill="none" stroke="#ffffff" stroke-width="4"/>
  <text x="$center" y="65" text-anchor="middle" class="math" font-size="$size">$top</text>
  <text x="$center" y="155" text-anchor="middle" class="math" font-size="$size">$bottom</text>
</g>
"@
}

function ColumnVector4([int]$x, [int]$y, [string[]]$entries, [int]$width = 180, [int]$size = 56, [int]$rowGap = 70) {
    $rightInset = $width - 20
    $center = $width / 2
    $height = 4 * $rowGap + 40
    $firstBaseline = $rowGap / 2 + 30
    @(
        "<g transform='translate($x $y)'>"
        "<path d='M20 0H0V${height}H20 M$rightInset 0H${width}V${height}H$rightInset' fill='none' stroke='#ffffff' stroke-width='4'/>"
        for ($i = 0; $i -lt 4; $i++) {
            "<text x='$center' y='$($i * $rowGap + $firstBaseline)' text-anchor='middle' class='math' font-size='$size'>$($entries[$i])</text>"
        }
        '</g>'
    ) -join "`n"
}

function Matrix2([int]$x, [int]$y, [string[]]$entries) {
    @"
<g transform="translate($x $y)">
  <path d="M20 0H0V180H20 M210 0H230V180H210" fill="none" stroke="#ffffff" stroke-width="4"/>
  <text x="60" y="65" text-anchor="middle" class="math" font-size="56">$($entries[0])</text>
  <text x="170" y="65" text-anchor="middle" class="math" font-size="56">$($entries[1])</text>
  <text x="60" y="155" text-anchor="middle" class="math" font-size="56">$($entries[2])</text>
  <text x="170" y="155" text-anchor="middle" class="math" font-size="56">$($entries[3])</text>
</g>
"@
}

function Fraction([int]$x, [int]$y, [string]$numerator, [string]$denominator, [switch]$Compact) {
    $numeratorY = 0
    $denominatorY = 65
    $lineY = 15
    $lineLeft = 5
    $lineRight = 95
    if ($Compact) {
        $numeratorY = 8
        $denominatorY = 58
        $lineY = 18
        $lineLeft = 30
        $lineRight = 70
    }
    @"
<g transform="translate($x $y)">
  <text x="50" y="$numeratorY" text-anchor="middle" class="math" font-size="42">$numerator</text>
  <path d="M$lineLeft ${lineY}H$lineRight" stroke="#ffffff" stroke-width="3"/>
  <text x="50" y="$denominatorY" text-anchor="middle" class="math" font-size="42">$denominator</text>
</g>
"@
}

function InvSqrt2([int]$x, [int]$y) {
    Fraction $x $y '1' '&#x221A;2'
}

function Orbit([int]$x = 1450, [int]$y = 560) {
    @"
<g transform="translate($x $y)">
  <circle r="460" fill="url(#glow)"/>
  <circle r="300" fill="url(#grid)" stroke="#304580" stroke-width="2"/>
  <ellipse rx="300" ry="110" fill="none" stroke="#8da9ff" stroke-width="3" transform="rotate(-35)"/>
  <ellipse rx="300" ry="110" fill="none" stroke="#e7d450" stroke-width="3" transform="rotate(35)" opacity=".7"/>
  <path d="M-330 0H330 M0-330V330" stroke="#304580" stroke-width="2"/>
  <path d="M0 0L210-210" stroke="url(#accent)" stroke-width="8" marker-end="url(#arrow)"/>
  <circle r="12" fill="#ffffff"/><circle cx="210" cy="-210" r="16" fill="#e7d450"/>
  <text x="-205" y="385" class="math" font-size="46">|&#x03C8;&#x27E9; = &#x03B1;|0&#x27E9; + &#x03B2;|1&#x27E9;</text>
</g>
"@
}

function SaveSlide([string]$name, [string]$title, [string]$description, [string]$body, [string]$number, [string]$section = 'THE MATH BEHIND QUANTUM COMPUTING', [switch]$titleSlide, [string]$background = '') {
    if ($OnlySlides.Count -gt 0) {
        if ($name -notmatch '^slide-(\d+)\.svg$' -or [int]$Matches[1] -notin $OnlySlides) {
            return
        }
    }
    $safeTitle = [Security.SecurityElement]::Escape($title)
    $safeDescription = [Security.SecurityElement]::Escape($description)
    if ($titleSlide) {
        $slideHeader = @(
            "<image x='1305' y='285' width='290' height='290' href='$cloudbrewIcon'/>"
            "<image x='1150' y='605' width='600' height='155' href='$logo'/>"
        ) -join "`n"
        $slideFooter = ''
    } else {
        $slideHeader = @(
            (Text 100 100 $section 20 'label')
            "<image x='1500' y='55' width='320' height='83' href='$logo'/>"
        ) -join "`n"
        $slideFooter = @(
            '<path d="M100 985H1820" stroke="#304580"/>'
            "<a href='https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026'>$(Text 100 1030 'github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026' 24)</a>"
            "<text x='1820' y='1032' text-anchor='end' font-size='24' fill='#ffffff'>$number</text>"
        ) -join "`n"
    }
    $svg = @"
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="3840" height="2160" viewBox="0 0 1920 1080" role="img" aria-labelledby="title description">
<title id="title">$safeTitle</title>
<desc id="description">$safeDescription</desc>
$defs
<rect width="1920" height="1080" fill="#050f4a"/>
<image x="0" y="210" width="1920" height="870" opacity=".035" href="$cloud"/>
$background
<rect width="1920" height="8" fill="url(#accent)"/>
$slideHeader
$body
$slideFooter
<image x='1526' y='880' width='294' height='75' href='$zureLogo'/>
</svg>
"@
    [IO.File]::WriteAllText((Join-Path $slides $name), $svg, [Text.UTF8Encoding]::new($false))
}

$body = @(
    (Text 100 325 'Qubits Are' 104 'heading')
    (Text 100 445 'Vectors Too.' 104 'heading')
    '<rect x="100" y="495" width="180" height="8" fill="url(#accent)"/>'
    (Lines 100 585 @('The Math Behind', 'Quantum Computing') 44 62)
    (Text 100 805 'Johnny Hooyberghs' 34 'heading')
    (Text 100 860 'CloudBrew / Mechelen / 2026' 26)
) -join "`n"
SaveSlide 'slide-01.svg' 'Qubits Are Vectors Too' 'Title slide with the CloudBrew logo and cloud motif.' $body '01' 'LINEAR ALGEBRA. QUANTUM IDEAS. DEVELOPER INTUITION.' -titleSlide

$body = @(
    (Text 100 245 'Johnny Hooyberghs' 72 'heading')
    "<image x='145' y='345' width='430' height='430' preserveAspectRatio='xMidYMid slice' clip-path='url(#speaker-photo-clip)' href='$speakerPhoto'/>"
    '<circle cx="360" cy="560" r="215" fill="none" stroke="#8da9ff" stroke-width="3"/>'
) -join "`n"
# Uniform gap between the last line of one bullet and the next bullet.
$speakerBullets = @(
    @('Focus on .NET custom application development,', 'Azure Cloud, and GenAI'),
    @('18 years of professional experience as a', 'software enthusiast'),
    @('Interested in Quantum Computing'),
    @('Public speaker and trainer'),
    @('Microsoft MVP in Developer Technologies', 'and Microsoft Azure since 2020')
)
$bulletY = 390
foreach ($bullet in $speakerBullets) {
    $body += "`n<circle cx='750' cy='$($bulletY - 10)' r='7' fill='#e7d450'/>`n"
    $body += (Lines 780 $bulletY $bullet 34 44) -join "`n"
    $bulletY += 44 * $bullet.Count + 40
}
$speakerBackground = @"
<defs>
  <filter id="belgium-silhouette" x="-2%" y="-2%" width="104%" height="104%" color-interpolation-filters="sRGB">
    <feMorphology in="SourceAlpha" operator="dilate" radius="2" result="border"/>
    <feFlood flood-color="#304580"/>
    <feComposite in2="border" operator="in" result="outline"/>
    <feFlood flood-color="#091b68"/>
    <feComposite in2="SourceAlpha" operator="in" result="area"/>
    <feMerge><feMergeNode in="outline"/><feMergeNode in="area"/></feMerge>
  </filter>
</defs>
<image x="690" y="165" width="1080" height="790" href="$belgiumMap" filter="url(#belgium-silhouette)"/>
"@
SaveSlide 'slide-02.svg' 'Johnny Hooyberghs' 'Johnny Hooyberghs, Microsoft MVP and speaker, with his professional background and interests. A subtle silhouette of Belgium in the background marks his home country.' $body '02' 'ABOUT THE SPEAKER' -background $speakerBackground

$repoUrl = 'https://github.com/Djohnnie/QubitsAreVectorsToo-CloudBrew-2026'
$body = @(
    (Text 100 245 'Scan to visit the repository.' 72 'heading')
    "<a href='$repoUrl'><image x='690' y='300' width='540' height='540' href='$qrCode'/></a>"
) -join "`n"
SaveSlide 'slide-03.svg' 'Scan to visit the repository' 'Centered QR code linking to the GitHub repository for this presentation.' $body '03' 'FOLLOW ALONG'

$chapters = @(
    @{ Title = 'Introduction'; Heading = @('Introduction'); Subtitle = @('What is quantum computing', 'and why do we need it?'); Slide = 5 },
    @{ Title = 'Quantum Math'; Heading = @('Quantum', 'Math'); Subtitle = @('Is math important in quantum?'); Slide = 20 },
    @{ Title = 'Vectors'; Heading = @('Vectors'); Subtitle = @('What about vectors and linear algebra?'); Slide = 28 },
    @{ Title = 'Quantum Logic'; Heading = @('Quantum', 'Logic'); Subtitle = @('How is quantum probability logical?'); Slide = 36 },
    @{ Title = 'Quantum Code'; Heading = @('Quantum', 'Code'); Subtitle = @('How is Q# related to all of this?'); Slide = 54 }
)
$body = @(
    (Text 100 245 'Agenda' 72 'heading')
    (Text 100 315 'From quantum questions to quantum code.' 28)
) -join "`n"
for ($i = 0; $i -lt $chapters.Count; $i++) {
    $y = 380 + $i * 108
    $body += "<text x='110' y='$($y + 40)' class='label' style='font-size:60px'>$($i + 1)</text>"
    $body += (Text 230 ($y + 40) $chapters[$i].Title 42 'heading')
    $body += (Text 650 ($y + 40) ($chapters[$i].Subtitle -join ' ') 28)
    $body += "<path d='M230 $($y + 85)H1810' stroke='#304580'/>"
}
SaveSlide 'slide-04.svg' 'Agenda' 'Five chapters: Introduction, Quantum Math, Vectors, Quantum Logic, and Quantum Code.' $body '04' 'THE ROADMAP'

for ($i = 0; $i -lt $chapters.Count; $i++) {
    $chapter = $chapters[$i]
    $chapterNumber = $i + 1
    $body = @(
        '<circle cx="1500" cy="560" r="490" fill="url(#glow)"/>'
        "<text x='1500' y='560' text-anchor='middle' dominant-baseline='central' font-family='Montserrat' font-weight='700' font-size='550' style='fill:#091b68'>$chapterNumber</text>"
        (Text 100 395 "CHAPTER $chapterNumber" 24 'label')
        (Lines 100 535 $chapter.Heading 100 130 'heading')
        (Lines 100 835 $chapter.Subtitle 36 50)
    ) -join "`n"
    SaveSlide ('slide-{0:00}.svg' -f $chapter.Slide) $chapter.Title ($chapter.Subtitle -join ' ') $body ('{0:00}' -f $chapter.Slide) "CHAPTER $chapterNumber / $($chapter.Title.ToUpperInvariant())"
}

foreach ($reveal in @($false, $true)) {
    $body = @(
        (Text 100 245 'How many folds to reach the Moon?' 64 'heading')
        (Text 100 315 'A small start. An exponential journey.' 28)
        '<g aria-label="A sheet of A4 paper">'
        '<path d="M130 405H315L375 465V565H130Z" fill="#eeeeee" stroke="#96a8d2" stroke-width="3"/>'
        '<path d="M315 405V465H375" fill="#e2e7f4" stroke="#96a8d2" stroke-width="3"/>'
        '<path d="M160 495H335 M160 520H305" stroke="#091b68" stroke-width="4"/>'
        '</g>'
        (Text 425 440 'ONE SHEET OF A4' 20 'label')
        (Lines 425 495 @('Assume 0.1 mm thick.', 'Double it with every fold.') 30 50)
        if ($reveal) {
            Text 100 690 '42' 120 'heading'
        }
        (Text 345 635 'theoretical folds' 38 'heading')
        (Text 345 690 $(if ($reveal) { 'More than the Earth-Moon distance.' } else { 'Can one sheet reach the Moon?' }) 28)
        (Panel 100 740 830 115)
        if ($reveal) {
            '<text x="135" y="810" class="math" font-size="36">0.1 mm &#x00D7; 2<tspan baseline-shift="super" font-size="24">42</tspan> &#x2248; 439,805 km</text>'
        } else {
            '<text x="135" y="810" class="math" font-size="36">0.1 mm &#x00D7; 2<tspan baseline-shift="super" font-size="24">n</tspan> &#x2265; 384,400 km</text>'
        }
        '<g aria-label="Vector illustration of a folded-paper stack rising from Earth to the Moon">'
        '<circle cx="1385" cy="570" r="310" fill="url(#glow)"/>'
        '<g fill="#96a8d2"><circle cx="1110" cy="380" r="3"/><circle cx="1735" cy="460" r="3"/><circle cx="1190" cy="625" r="2"/><circle cx="1650" cy="330" r="2"/><circle cx="1790" cy="710" r="2"/></g>'
        '<circle cx="1405" cy="400" r="90" fill="#e2e7f4" stroke="#eeeeee" stroke-width="3"/>'
        '<g fill="#999999"><circle cx="1375" cy="365" r="22"/><circle cx="1440" cy="410" r="30"/><circle cx="1370" cy="440" r="14"/><circle cx="1420" cy="350" r="10"/></g>'
        (Text 1530 395 'MOON' 20 'label')
        '<path d="M1030 855Q1420 715 1810 855V865H1030Z" fill="#244758" stroke="#6b9baa" stroke-width="3"/>'
        '<path d="M1165 815L1205 799L1245 803L1270 787L1310 786L1295 810L1250 819L1225 839L1185 835Z M1525 791L1570 799L1590 815L1635 821L1660 843L1610 850L1575 833L1540 830Z" fill="#537c62"/>'
        '<path d="M1040 846Q1420 700 1800 846" fill="none" stroke="#6b9baa" stroke-width="5" opacity=".3"/>'
        '<path d="M1365 795V475L1405 455L1445 475V795" fill="#eeeeee" stroke="#e7d450" stroke-width="3"/>'
        '<path d="M1365 475L1405 495L1445 475 M1405 495V795" fill="none" stroke="#091b68" stroke-width="2"/>'
        '<g fill="none" stroke="#96a8d2" stroke-width="2">'
        for ($y = 515; $y -lt 790; $y += 16) {
            "<path d='M1365 $y L1405 $($y + 12) L1445 $y'/>"
        }
        '</g>'
        '<path d="M1505 495H1525 M1515 495V795 M1505 795H1525" fill="none" stroke="#e7d450" stroke-width="3"/>'
        (Text 1545 610 'Average distance' 28)
        '<text x="1545" y="655" class="math" font-size="30">&#x2248; 384,400 km</text>'
        (Text 1035 755 'EARTH' 20 'label')
        '</g>'
        (Text 100 930 'A thought experiment, not a practical folding challenge. Illustration not to scale.' 28)
    ) -join "`n"
    if ($reveal) {
        SaveSlide 'slide-07.svg' 'Paper folding to the Moon: answer' 'The same Earth, Moon, and paper-stack illustration reveals the answer: 42 theoretical folds. Starting at 0.1 mm and doubling each time gives about 439,805 km, beyond the average Earth-Moon distance of 384,400 km. Not physically achievable with an A4 sheet; illustration not to scale.' $body '07' 'INTRODUCTION / EXPONENTIAL GROWTH'
    } else {
        SaveSlide 'slide-06.svg' 'Paper folding to the Moon: question' 'How many theoretical folds would make a 0.1 mm sheet of A4 paper thick enough to reach the Moon? Each fold doubles the thickness. A vector illustration shows Earth below the Moon, with the average distance marked as 384,400 km. Illustration not to scale.' $body '06' 'INTRODUCTION / EXPONENTIAL GROWTH'
    }
}

$illustratedSlides = @(
    @{
        Title = 'Molecular chemistry & DNA'; Asset = 'molecular-chemistry.svg'
        Section = 'INTRODUCTION / REAL-WORLD PROBLEMS'
        Description = 'Molecular chemistry and DNA, illustrated with a double helix, chemical bonds, molecular structures, and a laboratory flask.'
    },
    @{
        Title = 'Global logistics & supply chains'; Asset = 'global-logistics.svg'
        Section = 'INTRODUCTION / REAL-WORLD PROBLEMS'
        Description = 'Global logistics and supply chains, illustrated with an aircraft, globe, delivery routes, cargo truck, shipping crates, and a checklist.'
    },
    @{
        Title = 'Cryptography & security'; Asset = 'cryptography-security.svg'
        Section = 'INTRODUCTION / REAL-WORLD PROBLEMS'
        Description = 'Cryptography and security, illustrated with a central padlock, two keys, binary digits, and circuit traces.'
    },
    @{
        Title = 'Electron spin'; Asset = 'electron-spin.svg'
        Section = 'INTRODUCTION / QUANTUM CONCEPTS'
        Description = 'A schematic of spin-up and spin-down basis states and their superposition, labeled spin up, spin down, and superposition. Arrows represent spin states, not literal rotation of an electron.'
        Note = 'The arrows mark a spin state along a chosen axis; an electron is not literally spinning like a ball.'
    },
    @{
        Title = "Schr$([char]0x00F6)dinger's cat"; Asset = 'schrodingers-cat.svg'
        Section = 'INTRODUCTION / QUANTUM CONCEPTS'
        Description = 'The cat thought experiment, with vector illustrations of the alive and dead outcomes side by side, each with a box and experimental apparatus.'
    },
    @{
        Title = 'Entangled electrons'; Asset = 'entangled-electrons.svg'
        Section = 'INTRODUCTION / QUANTUM CONCEPTS'
        Description = 'Two electrons with matching spin measurement outcomes, joined by an infinity-shaped link representing their correlated measurement results.'
        Note = 'Measure both and the outcomes agree, like the Bell state built in the final Q# example.'
    }
)
for ($i = 0; $i -lt $illustratedSlides.Count; $i++) {
    $illustratedSlide = $illustratedSlides[$i]
    $illustration = [IO.File]::ReadAllText((Join-Path $resources $illustratedSlide.Asset))
    $body = @(
        (Text 100 245 $illustratedSlide.Title 64 'heading')
        "<g transform='translate(100 330)'>$illustration</g>"
        if ($illustratedSlide.Note) {
            (Text 100 930 $illustratedSlide.Note 28)
        }
    ) -join "`n"
    $slideNumber = 8 + $i
    SaveSlide ('slide-{0:00}.svg' -f $slideNumber) $illustratedSlide.Title $illustratedSlide.Description $body ('{0:00}' -f $slideNumber) $illustratedSlide.Section
}

$body = @(
    '<text x="250" y="575" class="heading" style="fill:url(#accent)" font-size="220" opacity=".75">&#x201C;</text>'
    '<text x="960" y="475" text-anchor="middle" class="heading" font-size="64">I think I can safely say that nobody</text>'
    '<text x="960" y="565" text-anchor="middle" class="heading" font-size="64">understands quantum mechanics.</text>'
    '<text x="1670" y="670" text-anchor="end" class="heading" style="fill:url(#accent)" font-size="220" opacity=".75">&#x201D;</text>'
    '<circle cx="960" cy="635" r="5" fill="url(#accent)"/>'
    '<text x="960" y="710" text-anchor="middle" font-size="38" font-style="italic">Richard Feynman</text>'
    '<text x="960" y="755" text-anchor="middle" font-size="26">The Character of Physical Law, 1965</text>'
    '<text x="960" y="825" text-anchor="middle" font-size="28">Born 11 May 1918, Richard Feynman won the 1965 Nobel Prize in Physics and died on 15 February 1988.</text>'
) -join "`n"
SaveSlide 'slide-14.svg' 'A Feynman quote' 'Richard Feynman, in The Character of Physical Law (1965): I think I can safely say that nobody understands quantum mechanics. Born 11 May 1918, Richard Feynman won the 1965 Nobel Prize in Physics and died on 15 February 1988.' $body '14' 'INTRODUCTION / QUANTUM MECHANICS'

$hardwareSlides = @(
    @{
        Title = 'A quantum computer'; Asset = 'quantum-computer.jpg'
        Description = 'A photograph of the suspended cryogenic assembly of a quantum computer.'
    },
    @{
        Title = 'Vacuum tube computing'; Asset = 'vacuum-tube-computing.jpg'
        Description = 'A photograph of a historical computing module with vacuum tubes, resistors, and wiring.'
    },
    @{
        Title = 'Superconducting qubits'; Asset = 'superconducting-qubits.jpg'
        Description = 'A photograph of superconducting-qubit hardware, showing a close-up of cryogenic wiring and connections.'
    },
    @{
        Title = 'Neutral atom qubits'; Asset = 'neutral-atom-qubits.jpg'
        Description = 'A photograph of the Pasqal ORION neutral-atom quantum computing apparatus.'
    },
    @{
        Title = 'Topological qubits & Majorana quasiparticles'; Asset = 'topological-qubits.jpg'
        Description = 'A photograph of Microsoft Majorana hardware for the source slide on topological qubits and Majorana quasiparticles.'
    }
)
for ($i = 0; $i -lt $hardwareSlides.Count; $i++) {
    $hardware = $hardwareSlides[$i]
    $photo = DataUri (Join-Path $resources $hardware.Asset) 'image/jpeg'
    $photoBackground = @(
        "<image class='hardware-photo' x='0' y='0' width='1920' height='1080' preserveAspectRatio='xMidYMid meet' href='$photo'/>"
        '<defs>'
        '<linearGradient id="photo-top-scrim" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#050f4a" stop-opacity=".95"/><stop offset=".65" stop-color="#050f4a" stop-opacity=".85"/><stop offset="1" stop-color="#050f4a" stop-opacity="0"/></linearGradient>'
        '<linearGradient id="photo-bottom-scrim" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#050f4a" stop-opacity="0"/><stop offset=".35" stop-color="#050f4a" stop-opacity=".8"/><stop offset="1" stop-color="#050f4a" stop-opacity=".95"/></linearGradient>'
        '</defs>'
        '<rect width="1920" height="380" fill="url(#photo-top-scrim)"/>'
        '<rect y="780" width="1920" height="300" fill="url(#photo-bottom-scrim)"/>'
    ) -join "`n"
    $slideNumber = 15 + $i
    SaveSlide ('slide-{0:00}.svg' -f $slideNumber) $hardware.Title $hardware.Description (Text 100 245 $hardware.Title 64 'heading') ('{0:00}' -f $slideNumber) "INTRODUCTION / HARDWARE" -background $photoBackground
}

# Unicode is represented by XML entities in formula markup.
$body = @(
    (Text 100 245 'Classical bits' 72 'heading')
    '<text x="650" y="665" text-anchor="middle" class="math" font-size="250">0</text>'
    '<text x="1270" y="665" text-anchor="middle" class="math" font-size="250">1</text>'
) -join "`n"
SaveSlide 'slide-21.svg' 'Classical bits' 'The two possible values of a classical bit, zero and one, displayed side by side.' $body '21' 'QUANTUM MATH / CLASSICAL BITS'

$body = @(
    (Text 100 245 'Quantum bits or qubits' 72 'heading')
    (Ket 650 645 '0' 170)
    (Ket 1270 645 '1' 170)
) -join "`n"
SaveSlide 'slide-22.svg' 'Quantum bits or qubits' 'The two computational-basis states of a qubit, ket zero and ket one, displayed side by side.' $body '22' 'QUANTUM MATH / QUBIT BASIS STATES'

$superpositionTitles = @('Qubits in superposition', 'Normalized qubit amplitudes', 'Complex qubit amplitudes')
$superpositionDescriptions = @(
    'A qubit in superposition is written as alpha ket zero plus beta ket one, with the amplitudes highlighted.'
    'A qubit in superposition is alpha ket zero plus beta ket one. Its amplitudes obey the normalization condition: the squared magnitude of alpha plus the squared magnitude of beta equals one.'
    'A normalized qubit has complex amplitudes alpha equals a plus bi and beta equals c plus di, where a, b, c, and d are real numbers and i squared equals minus one.'
)
for ($stage = 0; $stage -lt $superpositionTitles.Count; $stage++) {
    $body = @(
        (Text 100 245 'Quantum bits in superposition' 68 'heading')
        '<g class="superposition" transform="translate(960 560)">'
        '<text x="-326" y="0" text-anchor="middle" class="math" style="fill:url(#accent)" font-size="132" font-weight="700">&#x03B1;</text>'
        (Ket -186 0 '0' 132)
        '<text x="-6" y="0" text-anchor="middle" class="math" font-size="132">+</text>'
        '<text x="154" y="0" text-anchor="middle" class="math" style="fill:url(#accent)" font-size="132" font-weight="700">&#x03B2;</text>'
        (Ket 294 0 '1' 132)
        '</g>'
        if ($stage -ge 1) {
            '<text x="960" y="700" text-anchor="middle" class="math" font-size="64">|<tspan fill="url(#accent)" font-weight="700">&#x03B1;</tspan>|&#xB2; + |<tspan fill="url(#accent)" font-weight="700">&#x03B2;</tspan>|&#xB2; = 1</text>'
        }
        if ($stage -ge 2) {
            '<text x="960" y="820" text-anchor="middle" class="math" font-size="52" font-style="normal"><tspan fill="url(#accent)" font-weight="700">&#x03B1;</tspan> = a + b<tspan font-style="italic">i</tspan><tspan dx="90" fill="url(#accent)" font-weight="700">&#x03B2;</tspan> = c + d<tspan font-style="italic">i</tspan></text>'
            '<text x="100" y="930" font-size="28">a, b, c, d are real numbers; <tspan class="math" font-style="italic" style="fill:#e2e7f4">i</tspan>&#xB2; = &#x2212;1.</text>'
        }
    ) -join "`n"
    $slideNumber = 23 + $stage
    SaveSlide ('slide-{0:00}.svg' -f $slideNumber) $superpositionTitles[$stage] $superpositionDescriptions[$stage] $body ('{0:00}' -f $slideNumber) 'QUANTUM MATH / SUPERPOSITION'
}

$jointStateTerms = @{}
$indexedStateTerms = @{}
foreach ($qubitCount in 2..4) {
    $jointStateTerms[$qubitCount] = @(
        for ($basis = 0; $basis -lt [Math]::Pow(2, $qubitCount); $basis++) {
            $amplitude = '&#x{0:X4};' -f (0x03B1 + $basis)
            $bits = [Convert]::ToString($basis, 2).PadLeft($qubitCount, '0')
            "<tspan fill='url(#accent)' font-weight='700'>$amplitude</tspan>|$bits&#x27E9;"
        }
    )
    # Indexed amplitudes avoid Greek letters that read as o or pi.
    $indexedStateTerms[$qubitCount] = @(
        for ($basis = 0; $basis -lt [Math]::Pow(2, $qubitCount); $basis++) {
            $subscript = -join ([string]$basis).ToCharArray().ForEach({ '&#x{0:X4};' -f (0x2080 + [int][string]$_) })
            $bits = [Convert]::ToString($basis, 2).PadLeft($qubitCount, '0')
            "<tspan fill='url(#accent)' font-weight='700'>&#x03B1;$subscript</tspan>|$bits&#x27E9;"
        }
    )
}

$body = @(
    (Text 100 245 'The potential power of quantum' 68 'heading')
    '<text x="960" y="450" text-anchor="middle" class="heading" style="font-size:52px">2 qubits</text>'
    "<text x='960' y='610' text-anchor='middle' class='math' font-size='104'>$($jointStateTerms[2] -join ' + ')</text>"
) -join "`n"
SaveSlide 'slide-26.svg' 'Two qubits: four amplitudes' 'Two qubits have four complex amplitudes: alpha ket 00 plus beta ket 01 plus gamma ket 10 plus delta ket 11.' $body '26' 'QUANTUM MATH / THE POTENTIAL POWER OF QUANTUM'

$body = @(
    (Text 100 245 'The potential power of quantum' 68 'heading')
    '<text x="960" y="350" text-anchor="middle" class="heading" style="font-size:38px">2 qubits</text>'
    "<text x='960' y='430' text-anchor='middle' class='math' font-size='64'>$($indexedStateTerms[2] -join ' + ')</text>"
    '<text x="960" y="525" text-anchor="middle" class="heading" style="font-size:38px">3 qubits</text>'
    "<text x='960' y='600' text-anchor='middle' class='math' font-size='44'>$($indexedStateTerms[3] -join ' + ')</text>"
    '<text x="960" y="695" text-anchor="middle" class="heading" style="font-size:38px">4 qubits</text>'
    "<text x='960' y='760' text-anchor='middle' class='math' font-size='40'>$($indexedStateTerms[4][0..7] -join ' + ')</text>"
    "<text x='960' y='815' text-anchor='middle' class='math' font-size='40'>+ $($indexedStateTerms[4][8..15] -join ' + ')</text>"
) -join "`n"
SaveSlide 'slide-27.svg' 'More qubits, exponentially more amplitudes' 'The full state expansions for two, three, and four qubits contain four, eight, and sixteen independent complex amplitudes alpha 0 through alpha 15 before normalization. Each expansion lists every computational-basis state once in binary order.' $body '27' 'QUANTUM MATH / THE POTENTIAL POWER OF QUANTUM'

$body = (Text 100 245 'The Bloch sphere' 72 'heading')
for ($sphere = 0; $sphere -lt 2; $sphere++) {
    $x = 240 + 800 * $sphere
    $body += @(
        "<g class='bloch-sphere' transform='translate($x 280) scale(1.6)'>"
        '<g fill="none" stroke="#e7d450" stroke-width="0.9">'
        '<circle cx="200" cy="200" r="160" fill="#091b68"/>'
        '<path d="M360 200C360 233.115 288.306 260 200 260C111.694 260 40 233.115 40 200"/>'
        '<path d="M40 200C40 166.885 111.694 140 200 140C288.306 140 360 166.885 360 200" stroke-dasharray="3.47 3.47"/>'
        '<path d="M200 360C166.885 360 140 288.306 140 200C140 111.694 166.885 40 200 40"/>'
        '<path d="M200 40C233.115 40 260 111.694 260 200C260 288.306 233.115 360 200 360" stroke-dasharray="3.47 3.47"/>'
        '</g>'
        '<path d="M200 200V46.667 M200 200H353.333 M200 200L148.714 251.286" fill="none" stroke="#e2e7f4" stroke-width="1.4"/>'
        if ($sphere -eq 0) {
            '<path d="M195.833 48.333L200 40L204.167 48.333Z M351.667 195.833L360 200L351.667 204.167Z M152.839 253.054L144 256L146.946 247.161Z" fill="#e2e7f4"/>'
        }
        '<text x="370" y="203" class="math" font-size="20">x</text>'
        '<text x="130" y="273" class="math" font-size="20">y</text>'
        '<text x="196" y="30" class="math" font-size="20">z</text>'
        if ($sphere -eq 1) {
            '<path class="bloch-state-vector" d="M200 200L272.837 64.868" fill="none" stroke="url(#accent)" stroke-width="3.2" stroke-linecap="round"/>'
            '<path d="M268.378 64.359L276 59L275.714 68.313C274.868 65.49 271.201 63.513 268.378 64.359Z" fill="#e7d450"/>'
            '<text x="281" y="48" class="math" style="fill:url(#accent)" font-size="24">|&#x03C6;&#x27E9;</text>'
        }
        '</g>'
    ) -join "`n"
}
SaveSlide 'slide-29.svg' 'The Bloch sphere' 'Two vector Bloch-sphere diagrams side by side, with z up, x to the right, and y toward the viewer, plus solid and dashed latitude and longitude curves. The same orientation is used on every later sphere. The right-hand sphere adds a yellow arrow indicating the pure qubit state ket phi.' $body '29' 'VECTORS / THE BLOCH SPHERE'

$stateExamples = @(
    @{
        Title = 'Ket zero'; Ket = '0'; Alpha = '1'; Beta = '0'
        Normalization = '|&#x2009;1&#x2009;|&#xB2;&#x2002;+&#x2002;|&#x2009;0&#x2009;|&#xB2;&#x2002;=&#x2002;1'
        Sum = '1&#x2002;+&#x2002;0&#x2002;=&#x2002;1'
        EndX = 0; EndY = -230
        Angle = 0; AngleX = 95; AngleY = -120
        Description = 'Ket zero has alpha = 1 and beta = 0, so normalization gives 1 + 0 = 1. Its column vector is [1, 0], and its Bloch direction is the north pole.'
    }
    @{
        Title = 'Ket one'; Ket = '1'; Alpha = '0'; Beta = '1'
        Normalization = '|&#x2009;0&#x2009;|&#xB2;&#x2002;+&#x2002;|&#x2009;1&#x2009;|&#xB2;&#x2002;=&#x2002;1'
        Sum = '0&#x2002;+&#x2002;1&#x2002;=&#x2002;1'
        EndX = 0; EndY = 230
        Angle = 180; AngleX = 140; AngleY = 50
        SphereAngleX = 200; SphereAngleY = 120
        Arc = 'M0-75 A75 75 0 0 1 0 75'
        Description = 'Ket one has alpha = 0 and beta = 1, so normalization gives 0 + 1 = 1. Its column vector is [0, 1], and its Bloch direction is the south pole.'
    }
    @{
        Title = 'A perfect 50/50 superposition'; Ket = '+'
        EndX = 230; EndY = 0
        Angle = 90; AngleX = 125; AngleY = -100
        Arc = 'M0-75 A75 75 0 0 1 75 0'
        Description = 'Ket plus is the equal positive superposition: alpha = beta = 1/sqrt(2). Normalization gives 1/2 + 1/2 = 1. Its column has two entries of 1/sqrt(2), and its Bloch direction is positive x, not halfway between the poles.'
    }
)
$zeroKet = '|&#x2009;0&#x2009;&#x27E9;'
$oneKet = '|&#x2009;1&#x2009;&#x27E9;'
for ($stateIndex = 0; $stateIndex -lt $stateExamples.Count; $stateIndex++) {
    $state = $stateExamples[$stateIndex]
    $ket = "|&#x2009;$($state.Ket)&#x2009;&#x27E9;"
    $body = @(
        (Text 100 245 $state.Title 68 'heading')
        "<text x='420' y='410' text-anchor='middle' dominant-baseline='central' class='math' font-size='80'>$ket</text>"
        '<text x="540" y="410" text-anchor="middle" dominant-baseline="central" class="math" font-size="64">=</text>'
        if ($state.Ket -eq '+') {
            (ColumnVector 600 320 '' '' 180 54)
            "<g transform='translate(655 350) scale(.7)'>$(InvSqrt2 0 0)</g>"
            "<g transform='translate(655 440) scale(.7)'>$(InvSqrt2 0 0)</g>"
            '<g class="state-expansion" transform="translate(570 600)">'
            (InvSqrt2 -365 -15)
            "<text x='-245' y='20' class='math' font-size='58'>$zeroKet</text>"
            '<text x="-125" y="20" class="math" font-size="58">+</text>'
            (InvSqrt2 -45 -15)
            "<text x='75' y='20' class='math' font-size='58'>$oneKet</text>"
            '<text x="190" y="20" class="math" font-size="58">=</text>'
            "<text x='275' y='20' class='math' font-size='58'>$ket</text>"
            '</g>'
            '<g class="state-normalization" transform="translate(570 735)">'
            '<text x="-285" y="20" class="math" font-size="58">(</text>'
            (InvSqrt2 -265 -15)
            '<text x="-165" y="20" class="math" font-size="58">)<tspan baseline-shift="super" font-size="32">2</tspan></text>'
            '<text x="-70" y="20" text-anchor="middle" class="math" font-size="58">+</text>'
            '<text x="0" y="20" class="math" font-size="58">(</text>'
            (InvSqrt2 20 -15)
            '<text x="120" y="20" class="math" font-size="58">)<tspan baseline-shift="super" font-size="32">2</tspan></text>'
            '<text x="225" y="20" text-anchor="middle" class="math" font-size="58">=</text>'
            '<text x="300" y="20" text-anchor="middle" class="math" font-size="58">1</text>'
            '</g>'
            '<g class="state-probability-sum" transform="translate(570 870)">'
            (Fraction -250 -15 '1' '2')
            '<text x="-95" y="20" text-anchor="middle" class="math" font-size="58">+</text>'
            (Fraction -40 -15 '1' '2')
            '<text x="115" y="20" text-anchor="middle" class="math" font-size="58">=</text>'
            '<text x="200" y="20" text-anchor="middle" class="math" font-size="58">1</text>'
            '</g>'
        } else {
            (ColumnVector 600 320 $state.Alpha $state.Beta 180 64)
            "<text x='570' y='620' text-anchor='middle' class='math state-expansion' font-size='58'>$($state.Alpha)&#x2009;$zeroKet&#x2002;+&#x2002;$($state.Beta)&#x2009;$oneKet&#x2002;=&#x2002;$ket</text>"
            "<text x='570' y='755' text-anchor='middle' class='math state-normalization' font-size='54'>$($state.Normalization)</text>"
            "<text x='570' y='890' text-anchor='middle' class='math state-probability-sum' font-size='54'>$($state.Sum)</text>"
        }
        '<text x="1450" y="335" text-anchor="middle" class="label">BLOCH CIRCLE / REAL STATES</text>'
        '<g class="bloch-circle" transform="translate(1450 600) scale(.8)">'
        '<defs><linearGradient id="bloch-state-accent" gradientUnits="userSpaceOnUse" x1="0" y1="230" x2="230" y2="-230"><stop stop-color="#8da9ff"/><stop offset="1" stop-color="#e7d450"/></linearGradient><marker id="bloch-state-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="userSpaceOnUse" markerWidth="24" markerHeight="24" orient="auto"><path d="M0 0L10 5L0 10Z" fill="#e7d450"/></marker></defs>'
        '<circle r="230" fill="#091b68" stroke="#e7d450" stroke-width="2"/>'
        '<path d="M-250 0H250 M0-250V250" fill="none" stroke="#96a8d2" stroke-width="2"/>'
        "<text x='0' y='-265' text-anchor='middle' class='math' font-size='40'>$zeroKet</text>"
        "<text x='0' y='285' text-anchor='middle' class='math' font-size='40'>$oneKet</text>"
        '<text x="265" y="14" class="math" font-size="40">|&#x2009;+&#x2009;&#x27E9;</text>'
        "<path class='bloch-state-vector' d='M0 0L$($state.EndX) $($state.EndY)' fill='none' stroke='url(#bloch-state-accent)' stroke-width='7' marker-end='url(#bloch-state-arrow)'/>"
        if ($state.Angle -gt 0) {
            "<path class='bloch-angle-arc' d='$($state.Arc)' fill='none' stroke='#e2e7f4' stroke-width='2.5'/>"
        }
        "<text x='$($state.AngleX)' y='$($state.AngleY)' text-anchor='middle' class='math bloch-angle-label' font-size='34'>&#x03B8; = $($state.Angle)&#xB0;</text>"
        '<circle r="7" fill="#ffffff"/>'
        '</g>'
    ) -join "`n"
    $slideNumber = 30 + $stateIndex
    SaveSlide ('slide-{0:00}.svg' -f $slideNumber) $state.Title "$($state.Description) The Bloch polar angle from the north pole is $($state.Angle) degrees." $body ('{0:00}' -f $slideNumber) 'VECTORS / QUBIT STATES'
}

$body = @(
    (Text 100 245 'From amplitudes to Bloch angles.' 66 'heading')
    (Text 100 310 'For the normalized, real, nonnegative amplitudes on the previous three slides.' 28)
    '<text x="130" y="395" class="math" font-size="42">&#x03B1; = cos(</text>'
    (Fraction 295 360 '&#x03B8;' '2')
    '<text x="405" y="395" class="math" font-size="42">)</text>'
    '<text x="530" y="395" class="math" font-size="42">&#x03B2; = sin(</text>'
    (Fraction 695 360 '&#x03B8;' '2')
    '<text x="805" y="395" class="math" font-size="42">)</text>'
    '<text x="1080" y="395" class="math" font-size="44">&#x03B8;&#x2002;=&#x2002;2 arccos(&#x03B1;)</text>'
    '<defs><linearGradient id="sphere-state-accent" gradientUnits="userSpaceOnUse" x1="200" y1="360" x2="360" y2="40"><stop stop-color="#8da9ff"/><stop offset="1" stop-color="#e7d450"/></linearGradient><marker id="sphere-state-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerUnits="userSpaceOnUse" markerWidth="20" markerHeight="20" orient="auto"><path d="M0 0L10 5L0 10Z" fill="#e7d450"/></marker></defs>'
) -join "`n"
for ($stateIndex = 0; $stateIndex -lt $stateExamples.Count; $stateIndex++) {
    $state = $stateExamples[$stateIndex]
    $center = 360 + 600 * $stateIndex
    $sphereX = $center - 150
    $endX = 200 + [int]($state.EndX * 160 / 230)
    $endY = 200 + [int]($state.EndY * 160 / 230)
    $body += @(
        if ($state.Ket -eq '+') {
            "<text x='$center' y='465' text-anchor='middle' class='math' font-size='36'>|&#x2009;+&#x2009;&#x27E9;&#x2002;:&#x2002;&#x03B1; = &#x03B2;</text>"
        } else {
            "<text x='$center' y='465' text-anchor='middle' class='math' font-size='36'>|&#x2009;$($state.Ket)&#x2009;&#x27E9;&#x2002;:&#x2002;&#x03B1; = $($state.Alpha),&#x2002;&#x03B2; = $($state.Beta)</text>"
        }
        "<g class='bloch-sphere' transform='translate($sphereX 490) scale(.75)'>"
        '<g fill="none" stroke="#e7d450" stroke-width="1.4">'
        '<circle cx="200" cy="200" r="160" fill="#091b68"/>'
        '<path d="M360 200C360 233.115 288.306 260 200 260C111.694 260 40 233.115 40 200"/>'
        '<path d="M40 200C40 166.885 111.694 140 200 140C288.306 140 360 166.885 360 200" stroke-dasharray="4 4"/>'
        '<path d="M200 360C166.885 360 140 288.306 140 200C140 111.694 166.885 40 200 40"/>'
        '<path d="M200 40C233.115 40 260 111.694 260 200C260 288.306 233.115 360 200 360" stroke-dasharray="4 4"/>'
        '</g>'
        '<path d="M200 40V360 M200 200H360 M200 200L148 252" fill="none" stroke="#96a8d2" stroke-width="1.5"/>'
        "<text x='200' y='15' text-anchor='middle' class='math' font-size='36'>z / $zeroKet</text>"
        "<text x='200' y='395' text-anchor='middle' class='math' font-size='36'>$oneKet</text>"
        '<text x="375" y="190" class="math" font-size="36">x</text>'
        '<text x="375" y="235" class="math" font-size="36">|&#x2009;+&#x2009;&#x27E9;</text>'
        '<text x="115" y="290" class="math" font-size="36">y</text>'
        "<path class='bloch-state-vector' d='M200 200L$endX $endY' fill='none' stroke='url(#sphere-state-accent)' stroke-width='6' marker-end='url(#sphere-state-arrow)'/>"
        if ($state.Angle -gt 0) {
            $arcEndX = if ($state.Angle -eq 90) { 252 } else { 200 }
            $arcEndY = if ($state.Angle -eq 90) { 200 } else { 252 }
            "<path class='bloch-angle-arc' d='M200 148 A52 52 0 0 1 $arcEndX $arcEndY' fill='none' stroke='#ffffff' stroke-width='2.5'/>"
        }
        $labelX = if ($state.ContainsKey('SphereAngleX')) { $state.SphereAngleX } else { $state.AngleX }
        $labelY = if ($state.ContainsKey('SphereAngleY')) { $state.SphereAngleY } else { $state.AngleY }
        "<text x='$([int](200 + $labelX * .7))' y='$([int](200 + $labelY * .7))' text-anchor='middle' class='math bloch-angle-label' font-size='32'>&#x03B8; = $($state.Angle)&#xB0;</text>"
        '<circle cx="200" cy="200" r="5" fill="#ffffff"/>'
        '</g>'
        if ($state.Ket -eq '+') {
            "<g class='angle-calculation' transform='translate($center 850)'>"
            '<text x="-230" y="0" class="math" font-size="36">&#x03B8; = 2 arccos(</text>'
            "<g transform='translate(-5 -25) scale(.75)'>$(InvSqrt2 0 0)</g>"
            '<text x="85" y="0" class="math" font-size="36">) = 90&#xB0;</text>'
            '</g>'
        } else {
            "<text x='$center' y='850' text-anchor='middle' class='math angle-calculation' font-size='36'>&#x03B8; = 2 arccos($($state.Alpha)) = $($state.Angle)&#xB0;</text>"
        }
    ) -join "`n"
}
$body += Text 100 925 'Measure from +z. The amplitudes use the half-angle; complex phases need a second angle.' 28
SaveSlide 'slide-33.svg' 'From amplitudes to Bloch angles' 'Three wireframe Bloch spheres show ket zero at the north pole, ket one at the south pole, and the equal positive superposition ket plus along positive x. For normalized real nonnegative amplitudes, alpha = cos(theta/2), beta = sin(theta/2), and theta = 2 arccos(alpha). The worked calculations give 0, 180, and 90 degrees respectively, with angle labels and arcs on the spheres. General complex states also require an azimuthal angle for relative phase.' $body '33' 'VECTORS / BLOCH ANGLES'

$body = @(
    (Text 100 245 'Two qubits. Four basis states.' 68 'heading')
    '<text x="100" y="325" class="math" font-size="32">Ordered basis: |&#x2009;00&#x2009;&#x27E9;,&#x2002;|&#x2009;01&#x2009;&#x27E9;,&#x2002;|&#x2009;10&#x2009;&#x27E9;,&#x2002;|&#x2009;11&#x2009;&#x27E9;</text>'
) -join "`n"
$twoQubitStates = @('00', '01', '10', '11', '++')
for ($stateIndex = 0; $stateIndex -lt $twoQubitStates.Count; $stateIndex++) {
    $x = 100 + 344 * $stateIndex
    $matrixX = $x + 205
    $body += @(
        "<g class='two-qubit-state' data-state='$($twoQubitStates[$stateIndex])'>"
        "<text x='$x' y='625' class='math' font-size='44'>|&#x2009;$($twoQubitStates[$stateIndex])&#x2009;&#x27E9;</text>"
        "<text x='$($x + 150)' y='625' text-anchor='middle' class='math' font-size='44'>=</text>"
        if ($stateIndex -lt 4) {
            $entries = @('0', '0', '0', '0')
            $entries[$stateIndex] = '1'
            (ColumnVector4 $matrixX 400 $entries 110 56 90)
        } else {
            (ColumnVector4 $matrixX 400 @('', '', '', '') 110 56 90)
            for ($row = 0; $row -lt 4; $row++) {
                "<g class='superposition-entry' transform='translate($($matrixX + 20) $(443 + 90 * $row)) scale(.7)'>$(Fraction 0 0 '1' '2' -Compact)</g>"
            }
        }
        '</g>'
    ) -join "`n"
}
$body += @(
    '<text x="100" y="910" class="math" font-size="40">|&#x2009;++&#x2009;&#x27E9;&#x2002;=</text>'
    "<g transform='translate(305 875) scale(.75)'>$(Fraction 0 0 '1' '2' -Compact)</g>"
    '<text x="410" y="910" class="math" font-size="40">(|&#x2009;00&#x2009;&#x27E9;&#x2002;+&#x2002;|&#x2009;01&#x2009;&#x27E9;&#x2002;+&#x2002;|&#x2009;10&#x2009;&#x27E9;&#x2002;+&#x2002;|&#x2009;11&#x2009;&#x27E9;)</text>'
) -join "`n"
SaveSlide 'slide-34.svg' 'Two qubits and the joint state' 'Five four-entry column matrices in the ordered basis ket 00, ket 01, ket 10, ket 11. Each computational-basis state has a single 1 in its corresponding row and zeros elsewhere. The equal positive superposition ket plus plus has amplitude 1/2 in every row and equals one half times the sum of all four basis kets.' $body '34' 'VECTORS / TWO-QUBIT STATES'

$body = @(
    (Text 100 245 'The tensor product.' 68 'heading')
    '<text x="960" y="365" text-anchor="middle" class="math" font-size="54">|&#x2009;&#x03A8;&#x2009;&#x27E9;&#x2002;=&#x2002;|&#x2009;&#x03C8;&#x2009;&#x27E9;&#x2002;&#x2297;&#x2002;|&#x2009;&#x03C6;&#x2009;&#x27E9;</text>'
    (ColumnVector 500 500 '&#x03B1;' '&#x03B2;' 140 72)
    '<text x="730" y="590" text-anchor="middle" dominant-baseline="central" class="math" font-size="72">&#x2297;</text>'
    (ColumnVector 820 500 '&#x03B3;' '&#x03B4;' 140 72)
    '<text x="1050" y="590" text-anchor="middle" dominant-baseline="central" class="math" font-size="64">=</text>'
    (ColumnVector4 1140 430 @('&#x03B1;&#x03B3;', '&#x03B1;&#x03B4;', '&#x03B2;&#x03B3;', '&#x03B2;&#x03B4;') 280 64)
    '<text x="960" y="850" text-anchor="middle" font-size="30">For product states: multiply each entry by the entire second column.</text>'
) -join "`n"
SaveSlide 'slide-35.svg' 'Tensor product of two state columns' 'The tensor product of the columns alpha beta and gamma delta is the four-entry column alpha gamma, alpha delta, beta gamma, beta delta. This Kronecker product combines two single-qubit pure states into a product state.' $body '35' 'VECTORS / TENSOR PRODUCT'

function Matrix4([int]$x, [int]$y, [string[]]$entries) {
    @(
        "<g class='gate-matrix-4' transform='translate($x $y)'>"
        '<path d="M18 0H0V240H18 M302 0H320V240H302" fill="none" stroke="#ffffff" stroke-width="3"/>'
        for ($row = 0; $row -lt 4; $row++) {
            for ($column = 0; $column -lt 4; $column++) {
                "<text x='$(40 + 80 * $column)' y='$(43 + 60 * $row)' text-anchor='middle' class='math' font-size='40'>$($entries[4 * $row + $column])</text>"
            }
        }
        '</g>'
    ) -join "`n"
}

function BlochPoint([double[]]$v) {
    # Orthographic projection: the screen axes are orthonormal in 3D.
    @(
        (210 * (.8 * $v[0] - .6 * $v[1]))
        (210 * (.36 * $v[0] + .48 * $v[1] - .8 * $v[2]))
    )
}

function SvgNumber([double]$value) {
    $value.ToString('0.###', [Globalization.CultureInfo]::InvariantCulture)
}

function GateBloch([int]$x, [int]$y, [double[]]$axis, [double[]]$start, [bool]$rotate = $true) {
    $initial = BlochPoint $start
    $axisPoint = BlochPoint $axis
    $dot = $axis[0] * $start[0] + $axis[1] * $start[1] + $axis[2] * $start[2]
    $cross = @(
        ($axis[1] * $start[2] - $axis[2] * $start[1])
        ($axis[2] * $start[0] - $axis[0] * $start[2])
        ($axis[0] * $start[1] - $axis[1] * $start[0])
    )
    $trajectory = for ($step = 0; $step -le 40; $step++) {
        $angle = if ($rotate) { [Math]::PI * $step / 40 } else { 0 }
        $v = for ($component = 0; $component -lt 3; $component++) {
            $start[$component] * [Math]::Cos($angle) + $cross[$component] * [Math]::Sin($angle) + $axis[$component] * $dot * (1 - [Math]::Cos($angle))
        }
        $point = BlochPoint $v
        "$(SvgNumber $point[0]),$(SvgNumber $point[1])"
    }
    $end = $point
    @(
        "<g class='gate-bloch' transform='translate($x $y)'>"
        '<circle r="210" fill="#091b68" stroke="#96a8d2" stroke-width="2"/>'
        for ($plane = 0; $plane -lt 3; $plane++) {
            $points = for ($step = 0; $step -le 64; $step++) {
                $v = @(0.0, 0.0, 0.0)
                $v[$plane] = [Math]::Cos(2 * [Math]::PI * $step / 64)
                $v[($plane + 1) % 3] = [Math]::Sin(2 * [Math]::PI * $step / 64)
                $p = BlochPoint $v
                "$(SvgNumber $p[0]),$(SvgNumber $p[1])"
            }
            "<polyline points='$($points -join ' ')' fill='none' stroke='#e7d450' stroke-width='1.5' opacity='.4'/>"
        }
        for ($component = 0; $component -lt 3; $component++) {
            $v = @(0.0, 0.0, 0.0)
            $v[$component] = 1
            $p = BlochPoint $v
            "<path d='M$(SvgNumber (-1.15 * $p[0])) $(SvgNumber (-1.15 * $p[1]))L$(SvgNumber (1.15 * $p[0])) $(SvgNumber (1.15 * $p[1]))' stroke='#6b80b5' stroke-width='1.5'/>"
            "<text x='$(SvgNumber (1.3 * $p[0]))' y='$(SvgNumber (1.3 * $p[1] + 10))' text-anchor='middle' class='math' font-size='30'>$(@('x', 'y', 'z')[$component])</text>"
        }
        if ($rotate) {
            "<path class='rotation-axis' d='M$(SvgNumber (-1.2 * $axisPoint[0])) $(SvgNumber (-1.2 * $axisPoint[1]))L$(SvgNumber (1.2 * $axisPoint[0])) $(SvgNumber (1.2 * $axisPoint[1]))' stroke='#8da9ff' stroke-width='4' stroke-dasharray='8 6'/>"
            "<polyline class='rotation-trajectory' points='$($trajectory -join ' ')' fill='none' stroke='#e7d450' stroke-width='4' marker-end='url(#gate-arrow)'/>"
            "<path class='input-vector' d='M0 0L$(SvgNumber $initial[0]) $(SvgNumber $initial[1])' stroke='#e2e7f4' stroke-width='5'/>"
        }
        "<path class='output-vector' d='M0 0L$(SvgNumber $end[0]) $(SvgNumber $end[1])' stroke='#e7d450' stroke-width='6' marker-end='url(#gate-arrow)'/>"
        '<circle r="6" fill="#ffffff"/>'
        '</g>'
    ) -join "`n"
}

function GateEntry([int]$x, [int]$y, [string]$value) {
    if ($value -in '1/sqrt(2)', '-1/sqrt(2)') {
        $numerator = if ($value.StartsWith('-')) { '&#x2212;1' } else { '1' }
        "<g class='gate-fraction' transform='translate($($x - 40) $($y - 20)) scale(.8)'>$(Fraction 0 0 $numerator '&#x221A;2')</g>"
    } else {
        "<text x='$x' y='$($y + 16)' text-anchor='middle' class='math' font-size='48'>$value</text>"
    }
}

function GateMatrix2([int]$x, [int]$y, [string[]]$entries) {
    @(
        "<g class='gate-matrix-2' transform='translate($x $y)'>"
        '<path d="M18 0H0V250H18 M302 0H320V250H302" fill="none" stroke="#ffffff" stroke-width="4"/>'
        for ($row = 0; $row -lt 2; $row++) {
            for ($column = 0; $column -lt 2; $column++) {
                GateEntry (80 + 160 * $column) (65 + 120 * $row) $entries[2 * $row + $column]
            }
        }
        '</g>'
    ) -join "`n"
}

function GateColumn2([int]$x, [int]$y, [string[]]$entries) {
    @(
        "<g class='gate-column-2' transform='translate($x $y)'>"
        '<path d="M18 0H0V250H18 M132 0H150V250H132" fill="none" stroke="#ffffff" stroke-width="4"/>'
        (GateEntry 75 65 $entries[0])
        (GateEntry 75 185 $entries[1])
        '</g>'
    ) -join "`n"
}

$gateArrow = '<defs><marker id="gate-arrow" viewBox="0 0 10 10" refX="10" refY="5" markerUnits="userSpaceOnUse" markerWidth="16" markerHeight="16" orient="auto"><path d="M0 0L10 5L0 10Z" fill="#e7d450"/></marker></defs>'
$gates = @(
    @{
        Name = 'H'; Label = 'Hadamard'; Matrix = @('1/sqrt(2)', '1/sqrt(2)', '1/sqrt(2)', '-1/sqrt(2)')
        CircuitInput = '0'; CircuitOutput = '+'; MatrixShift = 52
        InputColumn = @('1', '0'); OutputColumn = @('1/sqrt(2)', '1/sqrt(2)')
        InputKet = '|0&#x27E9;'; OutputKet = '|+&#x27E9;'
        Zero = 'H|0&#x27E9; = |+&#x27E9;'; One = 'H|1&#x27E9; = |&#x2212;&#x27E9;'
        Rotation = '180 degrees about the diagonal x + z axis.'
        Axis = @([Math]::Sqrt(.5), 0, [Math]::Sqrt(.5)); Start = @(0, 0, 1)
        Mapping = '|0&#x27E9; (+z) &#x2192; |+&#x27E9; (+x)'
        BlochRule = '(x, y, z) &#x2192; (z, &#x2212;y, x)'
        Note = 'The diagonal axis stays fixed; H swaps the x and z directions.'
    },
    @{
        Name = 'X'; Label = 'Pauli X'; Matrix = @('0', '1', '1', '0')
        CircuitInput = '0'; CircuitOutput = '1'; MatrixShift = 59
        InputColumn = @('1', '0'); OutputColumn = @('0', '1')
        InputKet = '|0&#x27E9;'; OutputKet = '|1&#x27E9;'
        Zero = 'X|0&#x27E9; = |1&#x27E9;'; One = 'X|1&#x27E9; = |0&#x27E9;'
        Rotation = '180 degrees about the x axis.'
        Axis = @(1, 0, 0); Start = @(0, 0, 1)
        Mapping = '|0&#x27E9; (+z) &#x2192; |1&#x27E9; (&#x2212;z)'
        BlochRule = '(x, y, z) &#x2192; (x, &#x2212;y, &#x2212;z)'
        Note = 'A bit flip: X swaps the two computational-basis amplitudes.'
    },
    @{
        Name = 'Y'; Label = 'Pauli Y'; Matrix = @('0', '&#x2212;i', 'i', '0')
        CircuitInput = '0'; CircuitOutput = '1'; MatrixShift = 39
        InputColumn = @('1', '0'); OutputColumn = @('0', 'i')
        InputKet = '|0&#x27E9;'; OutputKet = 'i|1&#x27E9;'
        Zero = 'Y|0&#x27E9; = i|1&#x27E9;'; One = 'Y|1&#x27E9; = &#x2212;i|0&#x27E9;'
        Rotation = '180 degrees about the y axis.'
        Axis = @(0, 1, 0); Start = @(0, 0, 1)
        Mapping = '|0&#x27E9; (+z) &#x2192; i|1&#x27E9; (&#x2212;z)'
        BlochRule = '(x, y, z) &#x2192; (&#x2212;x, y, &#x2212;z)'
        Note = 'Keep the factors of i in the state vector; the sphere hides global phase.'
    },
    @{
        Name = 'Z'; Label = 'Pauli Z'; Matrix = @('1', '0', '0', '&#x2212;1')
        CircuitInput = '+'; CircuitOutput = '&#x2212;'; MatrixShift = 46
        InputColumn = @('1/sqrt(2)', '1/sqrt(2)'); OutputColumn = @('1/sqrt(2)', '-1/sqrt(2)')
        InputKet = '|+&#x27E9;'; OutputKet = '|&#x2212;&#x27E9;'
        Zero = 'Z|0&#x27E9; = |0&#x27E9;'; One = 'Z|1&#x27E9; = &#x2212;|1&#x27E9;'
        Rotation = '180 degrees about the z axis.'
        Axis = @(0, 0, 1); Start = @(1, 0, 0)
        Mapping = '|+&#x27E9; (+x) &#x2192; |&#x2212;&#x27E9; (&#x2212;x)'
        BlochRule = '(x, y, z) &#x2192; (&#x2212;x, &#x2212;y, z)'
        Note = 'A phase flip: the poles stay fixed, but superpositions change direction.'
    }
)
for ($i = 0; $i -lt $gates.Count; $i++) {
    $gate = $gates[$i]
    $name = $gate.Name
    $number = 37 + 3 * $i
    $body = @(
        (Text 100 245 "$name gate: circuit and matrix." 68 'heading')
        (Text 100 315 $(if ($name -eq 'Y') { 'Pauli Y / circuit kets shown up to global phase' } else { $gate.Label }) 28)
        "<text x='540' y='465' text-anchor='middle' class='math' font-size='54'>|$($gate.CircuitInput)&#x27E9;</text>"
        '<path d="M620 450H1300" stroke="#e2e7f4" stroke-width="4"/>'
        '<rect x="895" y="395" width="130" height="110" rx="10" fill="#091b68" stroke="#e7d450" stroke-width="3"/>'
        "<text x='960' y='468' text-anchor='middle' class='math' font-size='54'>$name</text>"
        "<text x='1380' y='465' text-anchor='middle' class='math' font-size='54'>|$($gate.CircuitOutput)&#x27E9;</text>"
        "<g class='circuit-transformation' transform='translate($($gate.MatrixShift) 0)'>"
        "<text x='520' y='765' class='math' font-size='54'>$name =</text>"
        (GateMatrix2 690 620 $gate.Matrix)
        "<text x='1120' y='705' class='math' font-size='40'>$($gate.Zero)</text>"
        "<text x='1120' y='795' class='math' font-size='40'>$($gate.One)</text>"
        '</g>'
    ) -join "`n"
    SaveSlide ('slide-{0:00}.svg' -f $number) "$name gate: circuit and matrix" "$($gate.Label) circuit with input and output kets, its transformation matrix, and its action on both basis states." $body "$number" "QUANTUM LOGIC / $name / CIRCUIT"

    $body = @(
        (Text 100 245 "$name gate: multiply and reverse." 68 'heading')
        "<text x='100' y='315' class='math' font-size='36'>$($gate.InputKet) &#x2192; $($gate.OutputKet) &#x2192; $($gate.InputKet)</text>"
        (Text 100 955 'Every gate is unitary: it keeps the vector normalized and can always be undone.' 28)
    ) -join "`n"
    for ($direction = 0; $direction -lt 2; $direction++) {
        $y = 380 + 285 * $direction
        $inputs = if ($direction -eq 0) { $gate.InputColumn } else { $gate.OutputColumn }
        $outputs = if ($direction -eq 0) { $gate.OutputColumn } else { $gate.InputColumn }
        $body += @(
            (GateMatrix2 380 $y $gate.Matrix)
            (GateColumn2 800 $y $inputs)
            "<text x='1010' y='$($y + 140)' class='math' font-size='48'>=</text>"
            (GateColumn2 1120 $y $outputs)
            "<text x='1330' y='$($y + 140)' class='math' font-size='48'>=</text>"
            "<text x='1420' y='$($y + 140)' class='math' font-size='48'>$(if ($direction -eq 0) { $gate.OutputKet } else { $gate.InputKet })</text>"
        ) -join "`n"
    }
    SaveSlide ('slide-{0:00}.svg' -f ($number + 1)) "$name gate: matrix multiplication" "$($gate.Label) matrix multiplication on a concrete input and output column, then back to the original state. All normalization factors are written inside the matrix and state columns; Y retains its imaginary phase. A footnote states that every gate is unitary: it keeps the vector normalized and can always be undone." $body "$($number + 1)" "QUANTUM LOGIC / $name / MULTIPLICATION"

    $body = @(
        (Text 100 245 "$name gate: the Bloch-sphere rotation." 64 'heading')
        (Text 100 315 $gate.Rotation 32)
        $gateArrow
        (GateBloch 530 610 $gate.Axis $gate.Start)
        (Text 950 440 'ROTATION BY 180 DEGREES' 20 'label')
        "<text x='950' y='520' class='math' font-size='38'>$($gate.Mapping)</text>"
        "<text x='950' y='600' class='math' font-size='38'>$($gate.BlochRule)</text>"
        (Lines 950 690 @('White vector: input. Yellow vector: output.', 'Yellow curve: rotation path.', 'Dashed blue line: the rotation axis.') 28 45)
        (Text 100 905 $gate.Note 28)
        (Text 100 950 'Shown up to global phase; a 3D surface point can project inside the circle.' 28)
    ) -join "`n"
    SaveSlide ('slide-{0:00}.svg' -f ($number + 2)) "$name gate: Bloch-sphere rotation" "$($gate.Label): $($gate.Rotation) The trajectory is an orthographic projection of a three-dimensional half-turn. Global phase is not visible on the Bloch sphere." $body "$($number + 2)" "QUANTUM LOGIC / $name / BLOCH SPHERE"
}

$cnotMatrix = @('1', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0')
$body = @(
    (Text 100 245 'CNOT: circuit and matrix.' 68 'heading')
    (Text 100 315 'Two qubits: the first is the control, the second is the target.' 30)
    '<path d="M620 415H1300 M620 525H1300 M960 415V525" stroke="#e2e7f4" stroke-width="4"/>'
    '<circle cx="960" cy="415" r="12" fill="#e7d450"/>'
    '<circle cx="960" cy="525" r="30" fill="#050f4a" stroke="#e7d450" stroke-width="4"/>'
    '<path d="M930 525H990 M960 495V555" stroke="#e7d450" stroke-width="4"/>'
    '<text x="540" y="430" text-anchor="middle" class="math" font-size="54">|1&#x27E9;</text>'
    '<text x="540" y="540" text-anchor="middle" class="math" font-size="54">|0&#x27E9;</text>'
    '<text x="1380" y="430" text-anchor="middle" class="math" font-size="54">|1&#x27E9;</text>'
    '<text x="1380" y="540" text-anchor="middle" class="math" font-size="54">|1&#x27E9;</text>'
    '<g class="circuit-transformation" transform="translate(59.4 0)">'
    '<text x="410" y="760" class="math" font-size="50">CNOT =</text>'
    (Matrix4 690 620 $cnotMatrix)
    '<text x="1120" y="705" class="math" font-size="38">CNOT|10&#x27E9; = |11&#x27E9;</text>'
    '<text x="1120" y="795" class="math" font-size="38">CNOT|11&#x27E9; = |10&#x27E9;</text>'
    '</g>'
) -join "`n"
SaveSlide 'slide-49.svg' 'CNOT gate: circuit and matrix' 'Controlled NOT with the first qubit as control and second as target. The four-by-four matrix fixes 00 and 01 and exchanges 10 and 11.' $body '49' 'QUANTUM LOGIC / CNOT / CIRCUIT'

$body = @(
    (Text 100 245 'CNOT: multiply and reverse.' 68 'heading')
    '<text x="100" y="315" class="math" font-size="36">|10&#x27E9; &#x2192; |11&#x27E9; &#x2192; |10&#x27E9;</text>'
    (Text 100 955 'CNOT is unitary too: it permutes the basis states and is its own inverse.' 28)
) -join "`n"
for ($direction = 0; $direction -lt 2; $direction++) {
    $y = 380 + 285 * $direction
    $inputEntries = if ($direction -eq 0) { @('0', '0', '1', '0') } else { @('0', '0', '0', '1') }
    $outputEntries = if ($direction -eq 0) { @('0', '0', '0', '1') } else { @('0', '0', '1', '0') }
    $body += @(
        (Matrix4 380 $y $cnotMatrix)
        (ColumnVector4 800 $y $inputEntries 150 40 50)
        "<text x='1010' y='$($y + 140)' class='math' font-size='48'>=</text>"
        (ColumnVector4 1120 $y $outputEntries 150 40 50)
        "<text x='1330' y='$($y + 140)' class='math' font-size='48'>=</text>"
        "<text x='1420' y='$($y + 140)' class='math' font-size='48'>|1$(if ($direction -eq 0) { '1' } else { '0' })&#x27E9;</text>"
    ) -join "`n"
}
SaveSlide 'slide-50.svg' 'CNOT gate: matrix multiplication' 'Concrete forward and reverse four-by-four matrix multiplication maps ket 10 to ket 11 and back. CNOT is its own inverse.' $body '50' 'QUANTUM LOGIC / CNOT / MULTIPLICATION'

function GateColumn4([int]$x, [int]$y, [string[]]$entries) {
    # Four-entry column, 280 tall; 1/sqrt(2) entries render as compact fractions.
    @(
        "<g class='gate-column-4' transform='translate($x $y)'>"
        '<path d="M18 0H0V280H18 M132 0H150V280H132" fill="none" stroke="#ffffff" stroke-width="4"/>'
        for ($row = 0; $row -lt 4; $row++) {
            $rowY = 35 + 70 * $row
            if ($entries[$row] -eq '1/sqrt(2)') {
                "<g class='gate-fraction' transform='translate(37.5 $($rowY - 13.5)) scale(.75)'>$(Fraction 0 0 '1' '&#x221A;2' -Compact)</g>"
            } else {
                "<text x='75' y='$($rowY + 15)' text-anchor='middle' class='math' font-size='44'>$($entries[$row])</text>"
            }
        }
        '</g>'
    ) -join "`n"
}

$bellKet = '(|00&#x27E9; + |11&#x27E9;)'
$plusZeroKet = '(|00&#x27E9; + |10&#x27E9;)'
$body = @(
    (Text 100 245 'CNOT: entangling two qubits.' 68 'heading')
    (Text 100 315 'H puts the control in superposition; CNOT then ties the target to it.' 30)
    '<path d="M620 415H1300 M620 525H1300 M1060 415V525" stroke="#e2e7f4" stroke-width="4"/>'
    '<rect x="735" y="360" width="130" height="110" rx="10" fill="#091b68" stroke="#e7d450" stroke-width="3"/>'
    '<text x="800" y="433" text-anchor="middle" class="math" font-size="54">H</text>'
    '<circle cx="1060" cy="415" r="12" fill="#e7d450"/>'
    '<circle cx="1060" cy="525" r="30" fill="#050f4a" stroke="#e7d450" stroke-width="4"/>'
    '<path d="M1030 525H1090 M1060 495V555" stroke="#e7d450" stroke-width="4"/>'
    '<text x="540" y="430" text-anchor="middle" class="math" font-size="54">|0&#x27E9;</text>'
    '<text x="540" y="540" text-anchor="middle" class="math" font-size="54">|0&#x27E9;</text>'
    '<path d="M1320 395Q1335 395 1335 410V455Q1335 470 1350 470Q1335 470 1335 485V530Q1335 545 1320 545" fill="none" stroke="#e2e7f4" stroke-width="3"/>'
    "<g transform='translate(1375 455) scale(.75)'>$(InvSqrt2 0 0)</g>"
    "<text x='1455' y='485' class='math' font-size='44'>$bellKet</text>"
    (Panel 100 640 520 230)
    (Panel 700 640 520 230)
    (Panel 1300 640 520 230)
    (Text 135 695 '1 / START' 24 'label')
    '<text x="135" y="755" class="math" font-size="30">|00&#x27E9; = |0&#x27E9; &#x2297; |0&#x27E9;</text>'
    (Lines 135 805 @('Both qubits in the ground state;', 'nothing is correlated yet.') 25 40)
    (Text 735 695 '2 / H ON THE CONTROL' 24 'label')
    "<g transform='translate(735 735) scale(.6)'>$(InvSqrt2 0 0)</g>"
    "<text x='800' y='755' class='math' font-size='30'>$plusZeroKet = |+&#x27E9; &#x2297; |0&#x27E9;</text>"
    (Lines 735 805 @('The control is 0 and 1 at once;', 'the target is still 0 in both branches.') 25 40)
    (Text 1335 695 '3 / CNOT' 24 'label')
    "<g transform='translate(1335 735) scale(.6)'>$(InvSqrt2 0 0)</g>"
    "<text x='1400' y='755' class='math' font-size='30'>$bellKet</text>"
    (Lines 1335 805 @('Only the control-1 branch flips its target;', 'now 00 and 11 are the only outcomes.') 25 40)
    "<path d='M635 755H685' fill='none' stroke='#e7d450' stroke-width='4' marker-end='url(#arrow)'/>"
    "<path d='M1235 755H1285' fill='none' stroke='#e7d450' stroke-width='4' marker-end='url(#arrow)'/>"
    (Text 100 950 'Measure either qubit and the other is fixed: no product of two single-qubit columns gives this state.' 26)
) -join "`n"
SaveSlide 'slide-51.svg' 'CNOT gate: entangling two qubits' 'Two-wire circuit in the same style as the CNOT slide: both qubits start in ket zero, a Hadamard gate acts on the control wire, then CNOT uses the first qubit as control and the second as target. A brace joins both output wires to the Bell state (ket 00 plus ket 11) divided by sqrt(2). Three panels trace the state: start in ket 00, after H the state is (ket 00 plus ket 10) over sqrt(2), and after CNOT only the ket 10 branch flips its target, giving (ket 00 plus ket 11) over sqrt(2). A footnote notes that the outcomes are correlated and that no product of single-qubit columns gives this state.' $body '51' 'QUANTUM LOGIC / CNOT / ENTANGLEMENT'

$hadamardMatrix = @('1/sqrt(2)', '1/sqrt(2)', '1/sqrt(2)', '-1/sqrt(2)')
$body = @(
    (Text 100 245 'Bell state, part 1: H, then tensor.' 68 'heading')
    (Text 100 315 'STEP 1 / H ON THE CONTROL QUBIT' 20 'label')
    (GateMatrix2 380 335 $hadamardMatrix)
    (GateColumn2 800 335 @('1', '0'))
    "<text x='1010' y='475' class='math' font-size='48'>=</text>"
    (GateColumn2 1120 335 @('1/sqrt(2)', '1/sqrt(2)'))
    "<text x='1330' y='475' class='math' font-size='48'>=</text>"
    "<text x='1420' y='475' class='math' font-size='48'>|+&#x27E9;</text>"
    (Text 100 625 'STEP 2 / TENSOR WITH THE TARGET QUBIT' 20 'label')
    (GateColumn2 380 650 @('1/sqrt(2)', '1/sqrt(2)'))
    "<text x='590' y='790' text-anchor='middle' class='math' font-size='48'>&#x2297;</text>"
    (GateColumn2 660 650 @('1', '0'))
    "<text x='870' y='790' class='math' font-size='48'>=</text>"
    (GateColumn4 960 635 @('1/sqrt(2)', '0', '1/sqrt(2)', '0'))
    "<text x='1170' y='790' class='math' font-size='48'>=</text>"
    "<g transform='translate(1260 760) scale(.75)'>$(InvSqrt2 0 0)</g>"
    "<text x='1340' y='790' class='math' font-size='40'>$plusZeroKet</text>"
    (Text 100 965 'Still a product state: each joint entry is one amplitude from each qubit multiplied.' 26)
) -join "`n"
SaveSlide 'slide-52.svg' 'Bell state, part 1: H and tensor product' 'Step 1 multiplies the Hadamard matrix by the column (1, 0) to get (1/sqrt(2), 1/sqrt(2)), which is ket plus. Step 2 takes the tensor product of that column with the target column (1, 0), giving the four-entry column (1/sqrt(2), 0, 1/sqrt(2), 0), equal to (ket 00 plus ket 10) divided by sqrt(2). A footnote notes that this is still a product state.' $body '52' 'QUANTUM LOGIC / CNOT / ENTANGLEMENT STEP 1 AND 2'

$body = @(
    (Text 100 245 'Bell state, part 2: CNOT entangles.' 68 'heading')
    (Text 100 315 'The 4 × 4 matrix acts on the joint column; only the third and fourth rows swap.' 30)
    (Text 100 385 'STEP 3 / CNOT ON THE JOINT STATE' 20 'label')
    (Matrix4 380 410 $cnotMatrix)
    (GateColumn4 800 390 @('1/sqrt(2)', '0', '1/sqrt(2)', '0'))
    "<text x='1010' y='545' class='math' font-size='48'>=</text>"
    (GateColumn4 1120 390 @('1/sqrt(2)', '0', '0', '1/sqrt(2)'))
    "<text x='1330' y='545' class='math' font-size='48'>=</text>"
    "<g transform='translate(1420 515) scale(.75)'>$(InvSqrt2 0 0)</g>"
    "<text x='1500' y='545' class='math' font-size='40'>$bellKet</text>"
    (Panel 100 700 840 175)
    (Panel 980 700 840 175)
    (Text 135 750 'MEASUREMENT' 20 'label')
    '<text x="135" y="800" class="math" font-size="30">|00&#x27E9;: 50%&#x2003;|11&#x27E9;: 50%&#x2003;|01&#x27E9;, |10&#x27E9;: never</text>'
    (Text 135 845 'The two outcomes always agree.' 25)
    (Text 1015 750 'NOT A PRODUCT STATE' 20 'label')
    '<text x="1015" y="800" class="math" font-size="30">&#x03B1;&#x03B3; = &#x03B2;&#x03B4; &#x2260; 0&#x2003;but&#x2003;&#x03B1;&#x03B4; = &#x03B2;&#x03B3; = 0</text>'
    (Text 1015 845 'No two single-qubit columns multiply to this.' 25)
    (Text 100 955 'Example 5 in Q# prints exactly these two amplitudes: 0.7071 for 00 and for 11.' 28)
) -join "`n"
SaveSlide 'slide-53.svg' 'Bell state, part 2: CNOT entangles' 'Step 3 multiplies the four-by-four CNOT matrix by the column (1/sqrt(2), 0, 1/sqrt(2), 0). Swapping the last two rows gives (1/sqrt(2), 0, 0, 1/sqrt(2)), which is (ket 00 plus ket 11) divided by sqrt(2). A measurement panel states 50 percent for 00, 50 percent for 11, and never 01 or 10, so the outcomes always agree. A second panel shows why this is not a product state: alpha gamma equals beta delta and is nonzero, while alpha delta equals beta gamma equals zero, which no single-qubit columns can satisfy. A footnote links to Q# example 5.' $body '53' 'QUANTUM LOGIC / CNOT / ENTANGLEMENT STEP 3'

$codeColors = @{
    namespace = '#e7d450'; import = '#e7d450'; operation = '#8da9ff'; use = '#8da9ff'
    Example1 = '#8ed8ec'; Example2 = '#8ed8ec'; Example3 = '#8ed8ec'; Example4 = '#8ed8ec'; Example5 = '#8ed8ec'
    Std = '#8ed8ec'; Diagnostics = '#8ed8ec'; Math = '#8ed8ec'
    Unit = '#8ed8ec'; Qubit = '#8ed8ec'
    EntryPoint = '#f6f0c0'; Main = '#f6f0c0'; DumpMachine = '#f6f0c0'
    X = '#f6f0c0'; H = '#f6f0c0'; Ry = '#f6f0c0'; PI = '#f6f0c0'; Reset = '#f6f0c0'
    CNOT = '#f6f0c0'; ResetAll = '#f6f0c0'
}
$codeExamples = @(
    @{
        Number = 1; Slide = 55; Amplitudes = @(1.0, 0.0); Title = 'Your first qubit in Q#'
        Notes = @('Default state: ket zero.', 'Diagnostics, not measurement.', 'Only nonzero amplitudes are listed.')
        Description = 'Syntax-highlighted Q# from the runnable example-1 project. The operation allocates one qubit, automatically initialized to ket zero, and calls Std.Diagnostics.DumpMachine to print the simulator state. A drawn table lists the single nonzero basis state: ket zero has amplitude 1 and probability 100 percent with phase zero. Diagnostics inspect the local simulator without measuring the qubit.'
    }
    @{
        Number = 2; Slide = 56; Amplitudes = @(0.0, 1.0); Title = 'Flip a qubit with the X gate'
        Notes = @('X flips ket zero to ket one.', 'Dump the state before resetting.', 'Reset to zero before releasing.')
        Description = 'Syntax-highlighted Q# from the runnable example-2 project. The operation allocates a qubit in ket zero, applies X, and prints the simulator state with DumpMachine. A drawn table lists the single nonzero basis state: ket one has amplitude 1 and probability 100 percent with phase zero. Reset returns the qubit to ket zero after diagnostics so it can be safely released.'
    }
    @{
        Number = 3; Slide = 57; Amplitudes = @([Math]::Sqrt(0.5), [Math]::Sqrt(0.5)); Title = 'Create a superposition with H'
        Notes = @('H creates an equal superposition.', 'Both outcomes have 50% probability.', 'Dump the state before resetting.')
        Description = 'Syntax-highlighted Q# from the runnable example-3 project. The operation allocates a qubit in ket zero and applies H to prepare ket plus. A drawn table shows both ket zero and ket one with amplitude 1/sqrt(2), displayed as 0.7071 + 0i, probability 50 percent, and phase zero. DumpMachine inspects this superposition before Reset returns the qubit to zero for safe release.'
    }
    @{
        Number = 4; Slide = 58; Amplitudes = @(0.5, [Math]::Sqrt(0.75)); Title = 'A 25% / 75% superposition with Ry'
        Notes = @('Ry rotates by 120 degrees.', 'Probabilities: 25% zero, 75% one.', 'Both amplitudes are real and positive.')
        Description = 'Syntax-highlighted Q# from the runnable example-4 project. Starting in ket zero, Ry rotates by 2 pi/3 radians, or 120 degrees. The resulting amplitudes are 1/2 for ket zero and sqrt(3)/2 for ket one, displayed as 0.5000 and 0.8660. The table shows probabilities 25 and 75 percent and zero phase for both states. DumpMachine precedes Reset for safe release.'
    }
    @{
        Number = 5; Slide = 59; Amplitudes = @([Math]::Sqrt(0.5), 0.0, 0.0, [Math]::Sqrt(0.5)); Title = 'Entangle two qubits with H and CNOT'
        Notes = @('H then CNOT creates a Bell state.', 'Only 00 and 11 occur: 50% each.', 'Measure both: their outcomes agree.')
        Description = 'Syntax-highlighted Q# from the runnable example-5 project. Two qubits start in ket 00. H on the first qubit followed by CNOT prepares the entangled Bell state (ket 00 plus ket 11) divided by sqrt(2). The simulator table lists the two nonzero basis states: 00 and 11 each have amplitude 0.7071 and probability 50 percent with phase zero; 01 and 10 have zero amplitude and are not listed. DumpMachine inspects the joint state before ResetAll safely releases both qubits.'
    }
)
foreach ($example in $codeExamples) {
    $codePath = "example-$($example.Number)\src\Main.qs"
    $body = @(
        (Text 100 245 "$($example.Title)." 68 'heading')
        '<style>.qsharp-code{font-family:Consolas,"Courier New",monospace;fill:#e2e7f4;white-space:pre}.simulator-table text{font-family:"STIX Two Math","Cambria Math",serif;font-size:30px;font-weight:400;text-anchor:middle;dominant-baseline:central}</style>'
        (Panel 100 345 800 540)
        (Text 155 390 $codePath 20 'label')
    ) -join "`n"
    $codeLines = [IO.File]::ReadAllLines((Join-Path $resources "code\example-$($example.Number).qs"))
    $lineGap = [Math]::Min(44, [Math]::Floor(400 / [Math]::Max(1, $codeLines.Count - 1)))
    for ($i = 0; $i -lt $codeLines.Count; $i++) {
        $highlighted = foreach ($token in [regex]::Matches($codeLines[$i], '\b\d+(?:\.\d+)?\b|[A-Za-z_][A-Za-z_0-9]*|[^A-Za-z_0-9]+')) {
            $escaped = [Security.SecurityElement]::Escape($token.Value)
            if ($codeColors.ContainsKey($token.Value)) {
                "<tspan fill='$($codeColors[$token.Value])'>$escaped</tspan>"
            } elseif ($token.Value -match '^\d') {
                "<tspan fill='#ffffff'>$escaped</tspan>"
            } else {
                $escaped
            }
        }
        $body += "<text x='155' y='$(445 + $lineGap * $i)' class='qsharp-code' font-size='28'>$($highlighted -join '')</text>"
    }
    # DumpMachine lists only basis states with nonzero amplitude.
    $visibleStates = @(0..($example.Amplitudes.Count - 1) | Where-Object { $example.Amplitudes[$_] -ne 0 })
    $qubitCount = [int][Math]::Log2($example.Amplitudes.Count)
    $rowCount = $visibleStates.Count
    $rowGap = 90
    $tableHeight = 90 + $rowCount * $rowGap
    $body += @(
        (Text 960 390 'SIMULATOR OUTPUT' 20 'label')
        (Panel 960 430 860 $tableHeight)
        '<g class="simulator-table">'
        '<text x="1050" y="475">Basis</text>'
        '<text x="1270" y="475">Amplitude</text>'
        '<text x="1535" y="475">Probability</text>'
        '<text x="1715" y="475">Phase</text>'
        for ($row = 0; $row -lt $rowCount; $row++) {
            "<path d='M990 $(520 + $row * $rowGap)H1790' fill='none' stroke='#304580' stroke-width='1.5'/>"
        }
    ) -join "`n"
    for ($row = 0; $row -lt $rowCount; $row++) {
        $bit = $visibleStates[$row]
        $basis = [Convert]::ToString($bit, 2).PadLeft($qubitCount, '0')
        $y = 520 + $rowGap / 2 + $rowGap * $row
        $real = $example.Amplitudes[$bit].ToString('F4', [Globalization.CultureInfo]::InvariantCulture)
        $probability = (100 * $example.Amplitudes[$bit] * $example.Amplitudes[$bit]).ToString('F4', [Globalization.CultureInfo]::InvariantCulture)
        $body += @(
            "<g class='simulator-state' data-ket='$basis'>"
            "<text x='1050' y='$y'>|&#x2009;$basis&#x2009;&#x27E9;</text>"
            "<text x='1270' y='$y' class='amplitude'>$real+0.0000𝑖</text>"
            "<text x='1535' y='$y' class='probability'>$probability%</text>"
            "<text x='1715' y='$y' class='phase'>0.0000</text>"
            '</g>'
        ) -join "`n"
    }
    $body += '</g>'
    $body += (Lines 960 (430 + $tableHeight + 55) $example.Notes 28 48) -join "`n"
    SaveSlide ('slide-{0:00}.svg' -f $example.Slide) $example.Title $example.Description $body ([string]$example.Slide) "QUANTUM CODE / EXAMPLE $($example.Number)"
}

$body = @(
    (Text 100 245 'Shor''s algorithm in Q#' 64 'heading')
    (Text 100 305 'The quantum routine estimates a period; classical arithmetic turns it into factors.' 28)
    (Text 100 350 'example-6\src\shor.qs  /  input n = 143' 20 'label')
    (Panel 100 390 520 360)
    (Panel 700 390 520 360)
    (Panel 1300 390 520 360)
    (Text 135 445 '1 / CHOOSE A BASE' 24 'label')
    (Lines 135 505 @('Choose a random a in 1..142.', 'If gcd(a, 143) > 1, a factor', 'is already found; otherwise', 'continue to quantum period finding.') 25 48)
    (Text 735 445 '2 / FIND THE PERIOD' 24 'label')
    (Lines 735 505 @('Estimate r such that aʳ ≡ 1', '(mod 143). Controlled modular', 'multiplication and semiclassical', 'phase estimation produce a', 'frequency estimate.') 25 46)
    (Text 1335 445 '3 / RECOVER FACTORS' 24 'label')
    (Lines 1335 505 @('Continued fractions recover r.', 'For even r, use gcd(a^(r/2) ± 1,', '143) to find non-trivial factors.', 'Retry if the period is unsuitable.') 25 48)
    "<path d='M635 565H685 M1235 565H1285' fill='none' stroke='#e7d450' stroke-width='4' marker-end='url(#arrow)'/>"
    (Panel 100 785 1720 92)
    (Text 155 845 'RESULT  /  143 = 11 × 13' 34 'heading')
    (Text 100 920 'Educational example with a small input; Shor combines quantum period finding with classical post-processing.' 24)
) -join "`n"
SaveSlide 'slide-60.svg' 'Example 6: Shor''s algorithm in Q#' "Explanation of example 6: Shor's algorithm picks a base, uses quantum phase estimation to estimate its multiplicative period, then applies continued fractions and greatest common divisors to recover the factors of 143." $body '60' 'QUANTUM CODE / EXAMPLE 6'

$body = @(
    (Text 100 245 'Any questions?' 64 'heading')
    '<rect x="100" y="295" width="180" height="8" fill="url(#accent)"/>'
    "<a href='$repoUrl'><image x='100' y='365' width='440' height='440' href='$qrCode'/></a>"
    '<g class="closing-takeaways" font-size="34" text-anchor="middle" transform="translate(0 53)">'
    '<text x="936.45" y="455">Qubits can be represented by <tspan fill="#e7d450">vectors</tspan></text>'
    '<text x="936.45" y="515">Gates apply unitary <tspan fill="#e7d450">transformations</tspan></text>'
    '<text x="936.45" y="575">Measurement picks one basis state at random;</text>'
    '<text x="936.45" y="635">algorithms make the <tspan fill="#e7d450">desired outcome</tspan> likely.</text>'
    '</g>'
    '<defs><linearGradient id="closing-vector-accent" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="138" y2="-184"><stop stop-color="#8da9ff"/><stop offset="1" stop-color="#e7d450"/></linearGradient><marker id="closing-vector-arrow" viewBox="0 0 10 10" refX="10" refY="5" markerUnits="userSpaceOnUse" markerWidth="22" markerHeight="22" orient="auto"><path d="M0 0L10 5L0 10Z" fill="#e7d450"/></marker></defs>'
    '<g class="closing-bloch-sphere" transform="translate(1560 545) scale(.65)">'
    '<circle r="340" fill="url(#glow)"/>'
    '<circle r="230" fill="#091b68" fill-opacity=".5" stroke="url(#accent)" stroke-width="3"/>'
    '<path d="M-230 0A230 85 0 0 1 230 0" fill="none" stroke="#e7d450" stroke-width="3" stroke-dasharray="7 7" opacity=".55"/>'
    '<path d="M230 0A230 85 0 0 1-230 0" fill="none" stroke="#e7d450" stroke-width="3"/>'
    '<path d="M0-230A85 230 0 0 1 0 230" fill="none" stroke="#8da9ff" stroke-width="3" stroke-dasharray="7 7" opacity=".65"/>'
    '<path d="M0 230A85 230 0 0 1 0-230" fill="none" stroke="#8da9ff" stroke-width="3"/>'
    '<path d="M0-265V265 M-265 0H265 M100-100L-185 185" fill="none" stroke="#96a8d2" stroke-width="2"/>'
    '<text x="0" y="-285" text-anchor="middle" class="math" font-size="34">z</text>'
    '<text x="285" y="10" class="math" font-size="34">x</text>'
    '<text x="-210" y="215" class="math" font-size="34">y</text>'
    '<path class="bloch-state-vector" d="M0 0L138-184" fill="none" stroke="url(#closing-vector-accent)" stroke-width="8" marker-end="url(#closing-vector-arrow)"/>'
    '<circle r="7" fill="#ffffff"/>'
    '</g>'
    (Text 100 940 'Johnny Hooyberghs / Qubits Are Vectors Too' 26)
) -join "`n"
SaveSlide 'slide-61.svg' 'Thank you and questions' 'Closing slide with a thank-you heading, questions, a linked repository QR code, and a colorful Bloch sphere with a state vector. Qubits can be represented by vectors. Gates apply unitary transformations. Measurement picks one basis state at random; algorithms make the desired outcome likely.' $body '61' 'THANK YOU'

$body = @(
    (Text 100 245 'Your slide title' 72 'heading')
    (Text 100 315 'Optional subtitle / one clear idea per slide' 28)
    (Panel 100 390 1720 490)
    (Text 155 470 'CONTENT AREA' 20 'label')
    (Lines 155 585 @('Replace with a diagram, a formula, or a short story.', 'Use the existing layouts as starting points.') 38 65 'heading')
    (Text 155 790 'Keep essential content inside the 100 px safe margins.' 28)
) -join "`n"
SaveSlide 'slide-template.svg' 'Reusable content template' 'Blank branded content layout, excluded from the PowerPoint export.' $body '--' 'SECTION / TOPIC'

if ($OnlySlides.Count -gt 0) {
    Write-Host "Built selected slides in $slides"
} else {
    Write-Host "Built 61 starter slides and slide-template.svg in $slides"
}
