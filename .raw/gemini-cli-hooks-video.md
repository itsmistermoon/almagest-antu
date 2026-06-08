Hey.
Hey,
hey,
hey.
&gt;&gt; [music]
&gt;&gt; We are looking at a 5,000 share order.
&gt;&gt; Hello everyone at Welcome back to Google
Cloud Live. I'm Greg Boggas and I lead
the developer community team here at
Google Cloud. If you were with us last
week, you know, we kicked off this
series with the amazing Denise Quan from
the Gemini CLI team. We went through
Gemini CLI getting started. Uh we
started all the way from installation
and ended with Vibe coding a game. So if
you're just getting started, you can
check out that recording online. Uh
today we're going to be diving into more
advanced features of Gemini CLI hooks
and skills. We're also going to be
taking a look at a pre at a feature
that's now in preview which is plan
mode. And to help us go deeper on these
features, I am thrilled to bring in Jack
Weatherspoon. He works on the Gemini CLI
team, knows these features better than
just about anyone. Uh welcome to Google
Cloud Live, Jack.
&gt;&gt; Thanks for having me, Greg. excited to
be here and excited to dive a little
deeper and show off some features that
people might not have tried before as
well as give them a sneak peek like you
said at plan mode which should come out
in about a week or so.
&gt;&gt; Uh ju just in case we got folks joining
us here because we we have uh so many
viewers here across a whole bunch of
different channels. If someone's joining
us for the first time uh they've never
used uh Gemini CLI before, could you
just give the the brief sort of
introduction to it? What is Gemini CLI?
Why might a developer want to use it?
Yeah, for sure. Gemini CLI is a terminal
agent. So, it's runs in your terminal
like any other application and really it
just gives you the power of the Gemini
models directly in your terminal. So, it
has access to your files. It has access
to other tools that you have installed
on your machine. You can give it access
to MCP servers and really extend its
capabilities to really tailor it to
whatever workflows you might be using it
for. And it's really not only for
developers. We really think that anybody
can use Gemini CLI and get a lot of
value out of it.
&gt;&gt; Awesome. And uh just for folks who are
watching uh give you a little bit of
feel for what the next hour or so will
be like. Uh we're going to hit three
points. We're going to talk about hooks.
We're going to talk about skills. We're
going to talk about plan mode. We're
going to try to hit those, you know,
fairly succinctly up front. Uh and then
if you all have questions, we can dive
deeper as there's interest and and you
know, on the back half of the show or
so. So maybe to kick us off, uh, Jack,
you could, uh, tell us a little bit
about Hooks.
&gt;&gt; Yeah. Yeah. Yeah. Before we dive into
Hooks, let's quickly touch on kind of
the application that we'll be kind of
demoing and showcasing all of these
features within. So, if we head over to
my screen here, I've built out this nice
little fun demo application called
Memory Wall. Um, really this is for
myself personally. Uh, my wife always
throws things. We have a physical kind
of corkboard on the side of our fridge
that, you know, any sticky notes or
pictures we have, we throw on there. Um,
I'm always running out to the grocery
store and forgetting to take a picture
or look at it. I'm having
[clears throat] to text her to send me,
you know, the the recent updates on
what's on the list. Uh, so I decided to
create a kind of digital memory wall or
bulletin board so that no matter if I'm
on my phone, if I'm on my computer, I
can have all of the recent to-dos uh
visible for me. So, we have this kind of
memory wall and this is actually an
application that anyone watching if they
want to try out uh I think we'll put the
links in the chat. You can go over to
memory-wall.web.app
and actually try it out for yourself.
Create your own board. Double click to
add uh to add stuff. So, if we want to
go ahead, I can just double click here
and we'll actually change this to photo.
We'll go ahead and upload a photo.
I want to go to Greece. So, we'll get
some inspiration here.
We'll just go through this, upload it,
and then we can go ahead and pin that to
our board.
There we go. We've added something to
our memory board. Um, but now let's dive
into the fun stuff and talk about hooks
a little more.
&gt;&gt; Jack, just real quick. So, you built
this, I'm assuming, with Gemini CLI,
&gt;&gt; of course.
&gt;&gt; Yeah. And and can I get like a feel how
long did it take you to build this?
&gt;&gt; Yeah, good question. Uh, probably about
20 minutes or so. Uh really it's a
simple kind of 3JS and React application
that I then just deployed to Firebase
web hosting um as well as using Firebase
for the storage and and the images and
things like that. So it probably took
from start to finish about 20 to 25
minutes from idea to actually live
deployed application.
&gt;&gt; That's wild.
So, we'll switch over to my terminal
application and we'll start up Gemini
CLI by quickly typing Gemini.
And then we'll dive into hooks. You'll
actually see a hook that I have already
configured running on startup. So,
because we with this application, like I
said, it's kind of a React uh web
server. We want to be able to test all
of our changes before we deploy to
production. So, with that, we have a dev
server, right? We can write mpm rundev.
And what I've actually done is added a
hook. And what hooks are at a high level
are they are essentially scripts that
you can run at different life cycle
points of Gemini CLI's agentic loop. So
if we go ahead and actually just type
hooks here, we can go ahead and see our
configured hooks. So I actually have two
hooks already configured. And there's
those different event life cycles like I
talked about. So that can be like before
a tool call. So it can match against
certain tools and run your script or it
could be at the session start. So right
here we actually have a hook that
executes a script at the beginning of
any Gemini CLI session when we start up
and it's going to go ahead and actually
check to see if our dev server is
started and going to output that message
to the screen so that we can get a
warning or a heads up saying hey your
dev server is not running. um you need
to go ahead and start it so that as we
run through our session, if we want to
test things out against our dev server,
we can make sure it's running. Are you
with me so far, Greg? Is there anything
you think I should touch on a little
deeper here?
&gt;&gt; Uh this is this is great.
&gt;&gt; You know what? Actually, I'll I'll ask
one question. If what is like the hello
world with hooks look like? Like what is
the uh maybe like the very first hook
someone might might build might look
like?
&gt;&gt; Yeah, I would say to do things on edit
or write. So when Gemini CLI is writing
code, uh you can have a hook that
matches kind of those two tool calls. So
either editing or writing new code and
you can run things like a llinter,
right? So as Gemini CLI is um creating
that code, it's going to run like your
lint. So it could be if you're in Python
like running uh you know rough or if
you're in like node, it could be just
doing mpm run lint.
&gt;&gt; Yeah. So that way if the agent is having
any lint errors in the code it's
generating those will get picked up as
soon as those calls are made and then
it'll actually continue on and fix them
so that you don't have to run your
builds later on and and figure out that
something broke. Yeah. I I feel is it
fair to say that this is sort of adding
it gives you the ability to add
deterministic behavior in the agentic
loop which often can feel a little bit
too indeterministic.
&gt;&gt; Exactly. So you could have a different
session start hook that would you know
maybe you know do a summary of your last
five git commits and repositories. So if
you're jumping back to a new project
[clears throat] that you haven't touched
on in a while it can actually load those
kind of context in at the beginning and
you can you know then ask or you could
do uh uh a check for not having any
console.log statements so that you make
sure none of those get to production.
Right? So like things that you might not
want to have to check, you can have
those deterministic scripts run at those
different points.
&gt;&gt; Awesome.
&gt;&gt; So if we actually jump over to the code
here, um how does this actually
configure a hook? Um so like I said in
in your settings.json, which is kind of
your main configuration file for Gemini
CLI, you have these hooks parameters and
then you have the different events. And
in our documentation you can see all
these different events but session start
is the one I mentioned where whenever
you start a new session it runs.
So essentially it's just a name a type
which is command and then the command to
execute. So we have our start dev server
script and that just goes in a kind of
wherever you want but we have it in a
hex in hex folder and it's really just a
bash script but it could be a python
script node script again whatever kind
of logic you want to run to check. And
what we have configured is it's just
going to check to see our uh React
application. Is it running on port 5173
or 5174? So it's a pretty, you know,
basic hook. We're just checking is there
something running on these ports. And
then we're going to go ahead and send
Gemini CLI a different system message,
which is what you see in screen. I'll
show you in a sec. And either it's going
to say, you know, it's running or it's
going to say we're not running. And the
fun thing here is we can actually pass
context to Gemini CLI. So we can
actually send this message into its
context so that when we go ahead and do
our first prompt, it'll actually have
this information kind of already in the
turn. So we can actually say the
development server is not running.
Please check if the user wants to run it
in the background.
&gt;&gt; That's cool.
&gt;&gt; So we'll just go ahead and clear this.
And so that's where that message is
coming from that script, right? It's
checking it's saying it's not we don't
have anything on port 5173. go ahead and
output the dev server is not running.
So if we go ahead and send our first
message, we can then ask it to go ahead
and run the dev server
in the background for us. Um,
and it's going to go ahead and ask us if
it wants to run the command. We'll go
ahead and allow that. And you can see
this is one of the newer features that a
lot of folks have asked for here is we
can actually see that this was run in
the background. So prior uh this would
actually kind of block and Gemini CLI
would kind of be waiting on the current
task that's executing. Now it has the
ability to put those into the
background. So Gemini CLI can actually
uh very smartly detect whether or not
things like dev servers or longunning
processes if those can get put to the
background uh or you can put them to the
background yourself with control plusb
&gt;&gt; that's super helpful
&gt;&gt; and actually presstrl +b we can pull it
up and you can also see down here on the
right you'll actually know when
background shells are running so you can
actually see that this one background
task is running Um, and you can monitor
it here uh by doing control plus plus uh
control plus B.
&gt;&gt; I feel like that's so helpful. I feel
like in the past I felt like I needed to
start the servers myself in a different
terminal because Gemini CLI would get
stuck on those. And so now I can start
it up, throw it in the background and
then continue iterating and building.
&gt;&gt; Yeah, you can see now that we refresh on
our local host, we can see that we have
dev server is running. we can see our
memory application. So now we can kind
of continue on and test things uh before
we push to production.
&gt;&gt; And so this version here, this is
running locally.
&gt;&gt; Exactly.
&gt;&gt; Yeah.
&gt;&gt; Very cool.
Um so just to make sure I understand
this right. So for a hook, there's a set
of predefined events. Folks can find
what all those events, all those
triggers are in the docs. And then uh
you're going to define your hooks in
JSON. When that event is triggered,
Gemini CLI is going to send some JSON uh
like execute your your command, execute
your script, and pass along some JSON.
Your script's going to do some stuff and
then your script's going to pass back
JSON to Gemini CLI to tell it how to
proceed.
&gt;&gt; Yeah, exactly. The the hooks kind of are
based off of just your standard input
and output. Um so they're well
structured. You have things like the
system message which is what you see
appear in the UI. So we saw that the dev
server is not running get published and
then we have other kind of depending on
the hook other context you can pass it.
So it could be something like a after
agent hook which is helpful for things
like the viral Ralph loops you can
actually have the agent not stop
continue on when normally it would have
just you know stopped. You can have it
continue on and actually send it another
prompt um to continue working and things
like that. So, it's very customizable.
And that's the point of Hooks is that if
something's not supported in Gemini CLI,
some type of functionality, there's a
really good chance that you can extend
Gemini CLI through hooks to accomplish
that.
Uh, one use case I've seen folks use
hooks for is to set up custom sounds
when uh, Gemini is like waiting for
their input. Uh, are there any other fun
ones from the community that you've seen
folks use?
Yeah, I've seen some fun ones with
actually kind of turning into an
orchestrator. So you can have multiple
Gemini CLI and then have kind of they're
all sending their inputs back to kind of
one command center kind of or
orchestrator where you can kind of see
all the different sessions that someone
has running at once and kind of see
their status. So that's one cool use
case. Um yeah,
&gt;&gt; very nice.
Very cool.
You uh you want to talk about skills?
Yeah, we can uh let's dive into skills.
So I have one skill already configured
and if I actually jump back to Gemini
CLI, you can list your skills with
running slashsklls list. Um and you can
see I have one skill configured
currently which is the 3JS expert. And
first we'll talk quickly about what are
skills. Um first off, skills are not
something that's specific to Gemini CLI.
Uh it's actually standardized. So agent
skills are something that have a
standard format. So if you're switching
between providers, switching between
anti-gravity and Gemini CLI per se, you
can actually bring your skills with you,
which is really nice. And skills are
essentially kind of bundled expertise is
what I call them. So you can have Gemini
CLI put on a specific kind of expert hat
in whatever area your skill is. Um, and
that it will load that in
[clears throat] just in time. So the
progressive disclosure is the big thing
about hooks. So instead of jamming
everything into a single context file,
uh you can actually have it have it in
skills and then when a skill is
triggered, it loads that context in puts
on that expertise for a certain task.
So that would be a big difference
between because some folks here might be
familiar with custom commands
uh but not skills. So it sounds like
that's that that how do you say it?
Progressive disclosure is a big
difference there.
Yeah. So, uh, custom commands are
essentially just kind of prepackaged
prompts. So, you run a slash command,
you execute that prompt, right? You're
just passing it that prompt, it's going
to execute it. Whereas, uh, skills
really are meant to be kind of I call
them almost like a library book, right?
They're like on the shelf. They're
sitting there. Uh, you have the front
matter, which is kind of YAML front
matter or markdown front matter, and
that's the name of the skill.
and the description. It's similar in a
way to how agents see MTP tools, right?
They see the name of the tool and the
description and then based on that they
decide to either call that tool. It's
very similar with skills, right? So
skills, the agent only sees the name of
the skill and the description and any
other kind of custom uh properties you
pass it like trigger words or things
like that. Um, so essentially it's in
its back pocket. It's sitting on the
shelf and when it's triggered, when it
says, "Okay, I need to activate this
skill." It's going to go ahead and reach
off that library in that manual and
start reading through it uh just in
time. Like I said, progressive
disclosure.
&gt;&gt; So custom commands are for the you are
for the user to trigger.
Skills are for the agent to trigger. Can
can a user manually trigger a skill? I
feel like that would that make sense?
&gt;&gt; Yeah, we're we're working on that right
now. So soon you will be able to just
like type a skill name to kind of
&gt;&gt; load in the skill automatically.
&gt;&gt; Um right now it's based off of the agent
deciding to
&gt;&gt; when to call a skill.
&gt;&gt; The trigger. So we have an example here.
&gt;&gt; Um I'm not someone who's an expert in
3JS, which is what our application is
built on. So we went ahead and asked
Gemini CLI to help us with this skill.
We told it to go do some research on
best practices uh and then put this into
a skill. And we'll show you in a second
how Gemini CLI actually has a built-in
skill to actually go ahead and create
skills. So if you just say, "Hey, I want
to create a skill for writing
documentation. Can you help me do so?"
It's going to go ahead and actually walk
you through the process.
So all of this information you see here,
all these reference files and things
like that are only loaded in
when you actually trigger the skill. So
your context stays clean. It's not
polluted until you get to the point of
actually wanting to do something, which
is really nice because you can have
skills, you could have 100 skills,
right, sitting, waiting, not activated.
That might only be useful in certain
scenarios like putting up a pull
request. You could have a skill that has
templates, the proper format for you.
You could have things for, like I said,
for docs writing. I have one for writing
blogs with all my past blogs as
reference. Um, so things that you can
just have them sit in the background.
Um, and they're not wasting context or
or tokens.
&gt;&gt; That feels so powerful. So so much of
skills is about what folks might refer
to as context engineering and like
context management.
&gt;&gt; Yeah, exactly. So we can try to see if
our 3JS expert will get activated. So we
can say something like
can you check
how our project does against 3JS
best practices
and something like this. You should see
that because we use words like 3JS which
are in our skill description that Gemini
CLI has successfully kind of activated
this skill. It's going to go ahead and
prompt us to load it in um because you
can load skills from like GitHub or
other things through the Gemini skills
install command. So you can actually
just have one that's on the web or have
one in a GitHub repository that all of
your team can install. Um, so they are
meant to be kind of bundled so that they
can be packaged up and shared.
&gt;&gt; I I guess same same question as last
time. Uh, any uh any cool skills from
the community? You see, it feels like
there's a pretty thriving um online
collection of skills.
&gt;&gt; Yeah, one of my favorite ones that I've
been having fun with that went mega
viral was the remote best practices
skill. I'm sure everyone saw videos of
that. essentially how you can create
really cool videos uh kind of these
motion graphics just from prompts in
your terminal and I've done a few with
Gemini CLI. It's it's pretty cool.
&gt;&gt; I did not see that. That's awesome.
&gt;&gt; So, we can go ahead and actually we're
seeing a sub aent get launched here
which is a couple built-in sub aents in
Gemini CLI. One of them is the codebase
investigator. There's another one for
CLI help. So actually if you asked
Gemini CLI to go ahead and say how do
hooks work like if you want to learn
more and you're not watching this video
or you want to go into the terminal
afterwards and really deep dive deep you
can actually just prompt Gemini CLI
saying how do Gemini CLI hooks work. It
has a built-in help with the docs for
Gemini CLI that it can kind of read um
and it'll actually iterate and feed back
to you how to do things. So, if you're
trying to set up hooks, that's actually
how I did the hooks for this video is
just prompted Gemini CLI, can you read
how hooks work and then, you know,
reference the docs to go ahead and
create them?
I feel like that's such a important and
often not discussed aspect of Gemini CLI
is not only can you use it to build
things, but you can use it to teach you
how to build things. And then you can
also use it to teach yourself about how
to use Gemini CLI.
&gt;&gt; Yeah, we're really trying to make that
kind of feedback loop pretty quick. Um,
you shouldn't have to hop between going
into, you know, Google Chrome and
opening up the docs. We really want the
CLI to be the place where it can pull
its own information, be up to date. Uh,
it can Google search, right? So you can
even ask it to just go ahead and search
the web uh search its own docs and it
should be able to do everything
contained inside the terminal making the
ter the terminal more even more powerful
than it already is.
&gt;&gt; That's amazing.
&gt;&gt; Yeah. So you can see we lo we we
activated our skill um we have a few
strengths u and then it has actually
some areas for improvement from the the
3JS uh skill that picked up the best
practices and it has a couple
recommendations for us to go and clean
up after this.
So I think that's
that's kind of the high level on skill.
Is there any questions you have, Greg?
Anything you want me to touch on a bit
more?
&gt;&gt; I think you already touched on this, but
just to double down on it, if somebody
wants to get started with skills, the
easiest way to do that is to ask Gemini
CLI to help them build one.
&gt;&gt; Yep, exactly. So let's just go ahead and
actually do that right now before we
dive into anything else. Let's just go
ahead and say like I mentioned engineers
myself I like working on features
working on cool things. The part that I
dread is then having to write the
documentation.
So our app right now memory wall has
zero documentation. So let's go ahead
and change that.
Let's create a
doc writer skill
that follows best practices
for writing
clean and concise
documentation
for our
memory wall application.
And you'll see that like we talked about
there's this built-in skill creator
skill within Gemini CLI that actually
will go ahead and trigger to kind of
walk us through a flow.
And we're actually seeing a different a
different new feature in Gemini CLI
actually pop up right now and that's
also launching this week is the ask user
tool which is a pretty powerful tool. I
am a little bit biased as I was the one
who created this tool. So
&gt;&gt; you created this
&gt;&gt; I added it was it's very popular in some
of the other providers right so the
ability to have Gemini CLI have this
interactive
kind of question be able to ask you
questions that's not just you writing in
text right previously it would just ask
you in text you'd have to type back the
answers now we actually have this
dialogue where it can be text questions
multiple choice questions uh yes no
questions Um,
&gt;&gt; yeah.
&gt;&gt; How does it decide when to ask questions
and what categories of questions to ask?
&gt;&gt; Yeah, it's right now it's pretty pretty
much up to the model, right? So, it's
kind of what task is it wanting. Is it
something where it wants text input or
is it something like, hey, I'm building
a node application from scratch. It
might ask you what kind of stack you
want to use. Do you want to use mean
stack? Do you want to use this
technology? What database do you want?
And it'll list you four options. Um, so
pretty cool.
&gt;&gt; This is great. I feel like
the hallmark often of a of a good
developer, a seasoned developer is that
they ask a whole bunch of questions
before they go off and start building.
And it's it's nice to see Gemini CLI do
a little bit of that as well.
&gt;&gt; Oh, look, it's even this is one thing
that whenever I write a blog, the tech
writers always come back to me and say
that I've used passive voice instead of
active voice. So this is Gemini CLI
picking up and helping me, saving me
some time here.
And then it'll just ask you to review
and you can go ahead and fire that off.
And then, you know, now the model knows
those answers and it'll start to build
out the skill for us and run through
these these flows.
&gt;&gt; Oh, that's great.
&gt;&gt; And oh wow, look at that.
&gt;&gt; And it's creating a style guide. So, we
can go ahead right after this and, you
know, upload a a proper style guide or
fix things based on our company or how
we like to have, you know, voice or
brand guidelines. Um, but we'll just go
ahead and accept the the base one for
now.
And it's adding these reference to the
skills. So, again, these are all things
that will not be loaded until the skill
gets activated. Um,
It's doing kind of a guide template
now. It's kind of just going to clean up
and activate the skill for us.
So now it's writing that skill.md which
is kind of the key file for for skills.
And then it has like these different
these different commands here to
actually go ahead and validate it. U
make sure that it's in the proper
format.
not have any syntax errors or uh any
structuring issues.
And you can you can actually see we're
asking we're getting another question.
So instead of Gemini CLI asking us to
type things in, we're just getting this
question dialogue. So do we want to have
it at our user scope so skills can be
user scoped which means you have them in
any project or do you want them specific
to your individual project? So just
memory wall or do we want it to be in
all of my Gemini CLI sessions?
Because this is kind of a doc skill
purely for our project, we'll add it in
the workspace scope.
And then we're going to go ahead and run
the command. And this is actually
another interesting feature. I'm kind of
stopping and pointing things out as we
go, is that this is actually an
interactive command, right? So it's
waiting for my input right now. Um,
that's one thing that Gemini CLI can do
that a lot of others can't is it can
actually run interactive commands that
require user input. Um, these would
normally hang in other applications, but
in Gemini CLI you can actually do these
interactive commands. And what's
happening here is Gemini CLI is actually
calling itself. It's calling one of its
own command command line commands to
actually install the skill. So if we
click on or press tab, we can shift
focus. So you can see here it says tab
to focus. If we click tab, we're now
focused in on the interactive piece. We
can go ahead and do Y and we'll submit.
And now that was actually calling that
command and doing an interactive uh
command within Gemini CLI.
And then after this finishes, we just
need to run slashkills reload.
And that will go ahead and activate our
new skill. We can see down here in the
bottom, we now have two skills. We
previously had one. And again, if we do
slashskills list, we can now see that
Gemini CLI has access to this new
docriter skill that helps to write
clean, concise documentation for our
application.
&gt;&gt; That's I like that a lot. I especially
like that skills reload. I like you
don't have to restart the CLI for uh for
that to take effect.
Yeah, exactly. You can just kind of stay
in your stay in the flow, stay in your
session and just kind of create them on
the go.
&gt;&gt; And now presumably when you would ask
then the model to help you write some
docs, it would know that it has that
skill and it would uh automatically
uh invoke that skill in order to to do
&gt;&gt; Yep. Can you write a docs page on
our keyboard shortcut?
And ideally, it's going to trigger the
skill and load it in.
&gt;&gt; Look at that.
&gt;&gt; Yeah. So, that's kind of kind of the
skills meta. And I would say the one
thing that I would focus on for teams
that unlock the most benefit is not
focus on individual skills for yourself.
Really focus on skills that can be used
across your team. like a doc writer
could be shared across your team. Um how
your team reviews code or creates PRs if
you have specific formats. Putting those
into skills, checking them into your
GitHub repository or whatever project
you're using. And that way you're kind
of having these skills unified across
across your team is a really big unlock.
And if you go to the Gemini CLI GitHub
repo, uh we have a few of those for like
PR creator skill that anyone who's open
source contributing, as soon as they
say, hey, can we create PR for whatever
fix we're working on, they use like our
defined flow, our defined template, and
Gemini CLI will kind of scaffold out ex
a PR exactly the way we need it for a
quick review.
&gt;&gt; That feels like a really good tip there.
um the and you touched on this briefly
with some of the permissions, but
there's going to be some skills, there's
going to be some hooks that you might
want to set up to work on all instances
of Gemini CLI anywhere on your machine.
There's going to be some that are just
going to be project specific. I suspect
there's even going to be times when you
might want a skill or a hook just for
yourself, but you don't want to commit
it to the repo. You don't want everyone
on that project to to have that, right?
Yeah, exactly. If you have some specific
kind of
jargon or coding logic or things that
you personally do but your teammates
might not might not want to adopt or or
do, you can have kind of your own
personal user skills that are or you
know Jack skills where it does things
how I like things or it talks like me
when it's writing when it's writing docs
or things like that. Right.
&gt;&gt; Yeah. Yeah. No, and I I think this is
all both of these are are great. And I
think both of these are um just really
interesting examples of trying to have
more consistency in the behavior
of these tools that are so powerful, but
sometimes the question is how do you
reach in and just grab a little bit more
control or how do you have more
consistency across the whole team if a
bunch of folks are using these tools?
And it feels like both of these just
give you um a little bit more power in
the behavior uh directing the behavior
of Gemini CLA.
&gt;&gt; Yeah, totally. And it's like trying to
make things more automated versus you
having to manually do things and and hop
back in to know do things exactly how
you like it. It's, you know, the agent
out of the box might not know all of
those things about how your team
operates or how to do things the most
efficiently. Um, so really giving it
skills, giving it hooks are ways that
you can customize things to your
specific project and and have things
work exactly how you your team does.
&gt;&gt; Uh, we had a question. Uh, I believe
it's Scvmet uh from YouTube asked,
"What's the best way to maintain and
share skills with the team?" Is that uh
checking it into the repo?
&gt;&gt; Yeah. So, if you're if you're doing
things that are in a GitHub repository,
exactly that. you just create a skills
folder and drop skills in there. And
that [clears throat] way when anyone is
working on that project with Gemini CLI
or with a different provider, they'll
get access to those skills and they'll
be able to trigger them and activate
them on the fly. Um, and then you'll
start to see there's lots of different
places like I believe it was Verscell.
Verscell has a NPX skills at where they
have a kind of a registrator going right
now where you can I think they have
thousands of skills already that people
are contributing. They're up voting. Um,
so that you can like if you want the
motion best practices skill, it's on
there. You just do npx add skills and
the name of the skill and it will
install it. Um, and you can publish
skills there as well. And so kind of
community is really growing around
skills right now. And there's lots of
areas to to publish so that something
that works well for you can be shared
with others.
&gt;&gt; And a question from my apologies is a
long name uh from YouTube. Uh, so I'm
just going to preface it to O Gundi and
uh not uh try the rest of it. Um, are
skills
um compatible across different uh CLIs?
Uh, so does it like can we use skills
here that are created for other CLIs?
&gt;&gt; Yeah. Yeah, totally. So you'll see we're
starting to standardize a bit more. Um,
skills for skills are still pretty new.
They just got standardized a few months
ago. Uh and before that you'll see like
I have this in ageemini folder skills.
We've also added support for reading
from aagents/skills.
So if I change this to aents it would
still work and get pulled into Gemini
CLI. Um and that's kind of our
standardized path is agent/skills.
other providers um will read from that
as well so that you can have your skills
in in just one folder and not have to
rename or do sim links or things like
that. So if you are using different
different applications different
providers agentskills is is the main one
that most folks support.
&gt;&gt; Amazing. Very cool. Uh so exciting to
see how um how quickly everything is
progressing here and and how we keep
inventing all these new tools to help us
work with these. Um all right, speaking
of earlier we were talking about uh
asking questions before going off and
developing. You want to talk a little
bit about plan mode?
&gt;&gt; Yeah, for sure. So let's talk about plan
mode. Plan mode is currently in preview.
I'll show you in a second how to enable
it if you do want to get started with it
before it's on by default. It will be on
by default uh in next week I believe on
Tuesday. So it is in preview. You can
try it out. We love if you have tried it
out give us feedback. Let us know what
we can change before we kind of launch
it for good. Um but plan mode is
essentially trying to fill the gap of
kind of a readonly mode where the tools
like editing, writing files are disabled
and it's just going to research, come up
with a plan and then give that plan back
to you to provide feedback um to iterate
on things like that. So that way that
you're not just typing something out
having Gemini CLI jump into editing
files. It's actually going to take a
step back, look at the codebase, read
through everything, and create a plan
that then you can execute on.
&gt;&gt; Can you give a feel for the types of
projects or when a developer might want
to use plan mode as opposed to the
default mode?
&gt;&gt; Yeah, for me, plan mode is when things
are a bit more ambiguous. you might not
have a clear easy to define
[clears throat] workflow or spec that
you're trying to to implement. So where
you want to maybe have
plan mode go out explore the codebase
give you two or three potentially
potential solutions ask for your
feedback. Hey what does which one makes
the most sense here for the project? Um
how do you like this this or this? Um,
and it's really just kind of the ability
to make sure that all the context and
all the requirements are are looked at,
the code is thoroughly looked through
before we go ahead and start
implementing. And the one thing that's
nice about plan mode too is that it
actually supports readonly MCP servers.
So MCP servers that annotate their any
tools as readon uh can also be accessed
during plan mode. So the GitHub MCP
server can actually go ahead and read
issues from GitHub. The Gemini CLI
extension for workspace also has those
type hints. So you can go and read
Google Docs, pull in Google Sheets,
things like that. Um pull in that
context during the planning stage uh
before you agree with Gemini CLI to go
ahead and implement.
&gt;&gt; So I like that way of thinking about
plan mode. Plan mode is readon mode.
plan plan mode can use readonly MCP
tools as well.
&gt;&gt; Yeah, exactly. And so we'll show it off.
Um, in our current memory wall
application, we don't really have a way
of linking different items on our board,
right? So, we're doing this live stream.
Maybe we want to link, you know, Jack
Greg to Google Cloud or do live stream
note or something like that or kind of
have it look like a, you know, an
evidence board where we can tie
different memories together. Maybe we're
on a trip, certain images are all from
that trip. We can link them, have some
nice visual red string on our memory
wall. Um, so let's see if we can go
ahead and implement that with plan mode
so that when we click on different
items, it links them together.
How's that sound?
&gt;&gt; Oh, sorry. It's on me. That sounds
great.
&gt;&gt; So, if you are trying plan mode before
it is released, uh you can just go to
settings and look up plan and set that
to true. Just toggle it. I have it on
true now. You'll just go ahead and and
click enter on it. Um to go ahead and
enable plan mode. This will also be I
will say um there are people who don't
necessarily want plan mode. So Gemini
CLI when you type in things like plan
can actually decide to enter plan mode
on your behalf like it'll prompt you hey
is this something you want to enter plan
mode for and get into kind of that
readonly state. Uh we do understand that
there are a lot of people out there who
have a certain planning kind of workflow
already developed. Like personally
sometimes I just like having a spec.md
markdown file that I'm kind of asking
Gemini CLI to iterate with me on hey can
we add this to the spec can we keep
going um so this will be a way to
disable plan mode as well once we launch
um on by default. Um so that's just
something to point out because there are
folks who might not want this by
default.
So then once you have it enabled you can
just do shift tab. You'll see down here
the color changes to green on the little
indicator and you'll see that you're in
plan mode. Um, so that's just a shift
tab to easily switch between the
different modes in Gemini CLI. There's
al also autoac accept edits which for
writing code or editing code will kind
of just approve editing those uh those
files. It won't allow any shell commands
or anything like that but it will accept
edits and write files.
So that's kind of how you can cycle
through. You can also just do slash plan
and then type out a prompt and it will
kind of start off that prompt in plan
mode as well.
So let's just go ahead and start typing
out. We want to add a new feature to our
memory
wall application.
We want to
be able to link
different notes [snorts] slash photos
together.
When you know select when
[clears throat] one image is selected
and we click on another one. Let's say
that links it together.
And then we'll just tell it what that
should look like visually.
And we'll just say that's a nice red
realistic string
connecting the two pins
And then we'll just say let's plan out
this feature. You don't have to say that
when you're in plan mode, but if you
were in regular mode and you said
something like let's plan out this
feature, that would toggle the enter
plan mode
tool so that you can go between the
different modes. Gemini CLI can also
figure out when you're trying to plan
and and go ahead and do that for you.
So now it'll just go ahead and and start
to read through. And the one thing about
plan mode is that it's a different
system prompt. So it's not going to
behave exactly the same. It's really
more on that gathering information,
trying to load in the context and
figuring out what you're asking for. And
you can see we're actually using the
flash model right now. So it's actually
quite quite speedy. Um by right now, I
believe currently in the preview it just
defaults to whatever model you have
selected. Um, but we're about to be
adding for when we launch the ability to
actually choose a different uh model for
planning specifically. So if you wanted
to use only Gemini Pro for planning but
for the default mode use flash that will
be supported.
&gt;&gt; So so this is come up with a plan.
Uh first well my first question what
does it do with that plan? Does it write
it to file? Does it just store it in
context? Yeah, right now it writes it to
a temporary
plan file in the Gemini temp directory.
&gt;&gt; Okay.
&gt;&gt; Uh in the future, this will also be uh I
believe a kind of ageemini plans folder.
&gt;&gt; So that in let's say we stopped this
session uh we came back two days from
now we would then be able to just go
slashplans
look through our plans and uh pick one
that we did a few days ago. So that is
that is the that is the goal um for the
first implementation. It's just doing it
to a temporary file.
&gt;&gt; So should I clear my context in between
the planning and the execution phase?
&gt;&gt; Yeah, that's a great question and that's
uh something that is kind of a hot
debate I would say right now. People
look at it both ways. Um because
during the plan, you've done all the
research. If it's a very technical plan,
like you're saying, you know, maybe it's
going through this for 10 plus minutes,
maybe you're at 50% of your context
window left by the time the plan's done,
then maybe you want to clear it and just
point it at the plan from the start so
that it has fresh context. It has the
plan and continues on. But at the same
time,
this the the flip side of it is that you
then might go and reread some files that
you already read, right, Greg? You might
it might need some of that context. So,
it's kind of currently, I think, up in
the air what people like to do more,
whether they want to clear
&gt;&gt; and uh start over or start start with
fresh context for the plan
&gt;&gt; for the implementation or continue on.
I think the answer to so many of these
questions is it depends or
&gt;&gt; a lot of it is user preference for sure
and how you how you want to do things
&gt;&gt; and you know user preference the
complexity of the project or feature
you're working on working with a group
individual vibe coding versus you know
green field versus a big complex
pre-existing project like there's just
so much nuance in all of these things uh
and then tell me here okay so It created
uh a plan and now it's asking, hey, are
you ready to start the implementation?
Um, it might be a little jarring for
folks.
Hey, I I did plan mode, but then now at
the end of plan mode, it's asking me, do
I want to edit files? So, could you talk
us through what it's doing now?
&gt;&gt; Yeah. So, essentially, you're going to
go step through the plan. You can read
through it, see the different steps, and
then there's a few different options
here. So if we you know if we see
something in the plan that we want it to
tweak or it's not how we're liking you
can just type feedback here directly
enter it and then it will iterate update
the plan and kind of give you the same
dialogue again with the updated version.
Otherwise you have two other options. So
you have the more restrictive one which
is kind of yes go into the regular
default mode which is where you're
approving edits and write files and then
you have the second one which is the
automatically accept edits and this is
the other mode that you saw when I did
shift tab that was yellow and it was
auto accept and what that means is the
writing files and editing files get
accepted automatically right so
essentially again like we just said
everything's user preference Yeah,
&gt;&gt; if you're really confident in the plan
that was put out, it's very detailed,
everything looks good, then you might
say, "Okay, let's just auto accept edits
and let's run wild with this." Right?
So, we'll do that here. Um, but if it's
something that you want to kind of keep
an eye on, you want to one by one make
sure the code is super high quality, um,
you might want to tweak how some of the
code is, uh, then you would do manually
accept. But we'll do we'll do auto
accept. And you can see uh
now we are going to go ahead and start
writing some of these files
I just switched modes by accident by
tapping. So now you can see when we're
in yellow mode here at the bottom we're
in auto accept edits mode. Um and you'll
see that we're not having to confirm
these tool calls uh for edits and
writes. They're just going to go ahead
and go through. So, it's adding in some
new functionality for the link that we
asked it to plan out.
&gt;&gt; Very nice.
All right. Uh, and this, like you said,
this is in preview now. If folks want it
now, they can update their settings to
see preview features. And this will be
released next week.
&gt;&gt; Yeah, exactly. Um, it's currently in
preview. We're still tweaking some
things like some of the colors or some
of the system prompt might be getting
tweaked a little bit to perform better.
Um, so yeah, give us your feedback, try
it out, let us know and help kind of
shape the launch of it. If there's
certain things that we're missing, let
us know. We'll get them in there before
before next week
&gt;&gt; and and they'll see it if they're using
the nightly build, right?
&gt;&gt; Yeah. So, we have three different kind
of release channels. Um there is the
stable version, the preview version, and
the nightly version. So stable is goes
out every week. Um it's the previous
week's preview, it gets promoted. So
essentially in the preview, if there's
anything that gets broken or doesn't
work um exactly how how we want it,
there's kind of that week uh leeway
before things get promoted. Um and then
nightly is essentially just takes a
snapshot every day of the code. Um, so
if you're if you're feeling super
adventurous and want to be on the
bleeding edge, um, you can npm install
the nightly version.
&gt;&gt; Amazing. Uh, you want to hit some
questions?
&gt;&gt; Yeah, sure. Let's hit some questions.
And while we do that, I will
just flip over and see if we can see if
our feature works.
&gt;&gt; Oh, great. Oh, yeah. Let's see.
&gt;&gt; Moment of truth.
Oh, looks like we're we're not getting
the links.
So, let's head back over and let's say
you can actually try to use our
playright MCP server
to test things out when things don't
work.
&gt;&gt; Uh, tell me about the Playright MCP
server.
&gt;&gt; Yeah, this is another this is an open
source one. It's one that I like to use
for when you're actually building
applications that have a UI or in the
browser. Essentially, it allows Gemini
CLI to through Playright to open up like
a local host, a browser, and actually
click around, test things out, and then
see how functionality works. So that
when I was actually building out this
application, I essentially just told
Gemini CLI, use the Playright MCP server
to test out the UI, make sure everything
works. Um, so that things like this
would just be kind of iterative, right?
it would add a new button, add a new
like clickable thing um feature to the
application. Playright would go test it
out. Something doesn't work, Playright
says that back to Gemini CLI. Hey, this
button's a dead link or you know this
thing's not working. Uh keep iterating
and then it helps improve.
&gt;&gt; This feels like a great segue to the
question from Aventura on YouTube. Um
should I stop using extensions then? Are
they still the same thing as skills? Are
skills and extensions the same? And and
let's throw MCP into the mix. There's a
lot of ways to add functionality on
here. Could you give the brief uh
overview on MCP versus skills versus
extensions?
&gt;&gt; For sure. Yeah. Good. I'll flip over to
our extensions gallery. Um I would say
no. It's not it's skills don't replace
um extensions. I would say if anything,
they actually make extensions more
powerful. So for folks who are not aware
of what Gemini CLI extensions are,
they're a way that you can kind of
bundle up all this functionality into a
package that users can just install with
a single click or a single command,
right? So like we said, checking things
into GitHub repositories for a team is
one way, but also bundling them as
extensions is another way to share that
out to other people. Right? So you can
see there's a lot of companies we have
skills for. The conductor extension is
one that a lot of people um really enjoy
for kind of spec driven deployment in
Gemini CLI. Um and again there's just
like this install command and you can
see that it brings in context. It brings
in custom commands. Um but you can also
bring in skills. Um and what that means
is a user can install this extension.
They get the MCP server skills whatever
that that extension has bundled uh all
allin-one. So I actually think it makes
extensions more powerful if anything.
&gt;&gt; Another question while you're on this
screen is from YCA
about conductor
&gt;&gt; and uh I saw the conductor extension on
there. The question was I don't
understand the difference between
conductor and plan mode. Which one is
deeper?
&gt;&gt; Yeah. So there's kind of some a little
bit of nuance there. conductor is like
it's actually going to be leveraging the
built-in plan mode and the built-in ask
user tool uh very shortly. So it's not
necessarily one or the other. Conductor
will actually use plan mode. Um but what
conductor does is it's a ve very kind of
heavy spec driven development. So it
does kind of these iterations of
planning, writing specs, um iterating on
them, saving different states so that if
you kind of you know leave and come back
um conductor has like a snapshot of your
context, what you were working on last.
Um so I think it it's really like if
you're going for a really big migration
or a very technical feature, maybe
conductor is for you. If you're just
trying to plan something out that's
pretty scoped, plan mode should get, you
know, 90% of the people there. But if
you're really diving deep, conductor is
great. And I can't say too much, but in
the future there might be a version of
like conductor might be built into
Gemini CLI so that you can just go
between kind of plan mode and like a
spec spec driven deployment mode.
&gt;&gt; I like that.
How's uh how's Gemini CLI doing there?
Oh, let's just see. We got to install
the Playright. We already have the MCP
server running. It's just going to go
ahead and do the test suite and we'll
actually be able to start doing some
[clears throat] some Playright tests.
Uh, for folks who haven't played with
this
before of hooking a browser up to their
agent of choice, this felt magical the
first time I ever saw it. And um, it's
also a feature of anti-gravity.
Anti-gravity can use Chrome to to test
the apps that it's building. And there
was a question here um from YouTube from
I'm just going to pref shorten this to
heck. My apologies. Uh it says regarding
Playright uh could you talk about the
difference between Gemini CLI using
Playright versus Chrome WebMCP?
&gt;&gt; Yeah. Um, I would say Chrome DevTools
MCP is awesome. If you're trying to
actually kind of look at the logs, uh,
performance, seeing why things are slow,
the Chrome DevTools MCP server is the
one for you. If you're just trying to
kind of automate testing, clicking
through the browser, um, the Playright
MCP is kind of like the light the
lighter weight Chrome dev tools is how I
would say it. So, for myself, it's
essentially just testing. Is the dev
server running? and I click through
things.
That's kind of where I use Playright. If
you're trying to hammer down on the
performance of your site, trying to look
through the logs, inspect things,
certain like elements on the page. Um,
that's kind of where I would do the
&gt;&gt; the the Chrome Web MCD is so powerful
for front-end debugging.
&gt;&gt; Yeah, it is. And like, let me see if I
can let me just tell it to
past our dev server is running. I
already know it is but
[clears throat]
it's trying to use my hook. There we go.
So, you can see I didn't I didn't open
that browser. That was
&gt;&gt; So, Gemini CLI just opened up this
browser. Yeah, exactly. It just opened
up this browser using the Playright MCP.
And if I wanted [clears throat] to say,
you know, click on this on this button,
I could actually just instruct it
through through Gemini CLI in the
terminal to test out different elements
and navigate through the UI
&gt;&gt; in the background. It looks like Yeah.
Okay, great. So, you can now give it
instructions
uh on how to test this app and Gemini
CLI can do that for you in the browser.
&gt;&gt; Yeah. And you can see it returns like
the the different background elements
and it it can see different UI elements
as well.
&gt;&gt; Really?
&gt;&gt; Let's see if it fix our
clicking clicking ability.
No pressure here. Gemini CLI.
&gt;&gt; That looks like it worked.
&gt;&gt; Yep. Looks like we can now just start
linking things together.
&gt;&gt; Incredible. Incredible.
&gt;&gt; There we go. Don't necessarily know if
those three are technically
related. Not sure groceries go with
Iceland, but uh [clears throat] there we
go. [snorts]
&gt;&gt; I don't Man, it is so easy to forget how
wild this is. You know, the you've done
Devril for a long time. How many live
coding demos have you done in the past
in your career where you meticulously
rehearse so that you can make sure you
can write the the proper 20 minutes or
20 lines of code, right?
um and way simple features. And here
you've got this app you built in 20
minutes before you just deployed this
non-trivial feature live on a call while
talking about other things the whole
time. And it's just absolutely
incredible like what these tools
&gt;&gt; I was a little scared there if I'm not
if I'm being fully honest. The live
demos are always
&gt;&gt; you kind of hope for the best. But here
you actually mentioned deploying it
live. This is actually still in our dev
&gt;&gt; Um
&gt;&gt; let's do that. Let's
or let's commit.
Let's just tell Gemini CLI commit those
changes. It's working and deploy. So
it's going to go ahead. It's going to go
ahead and stage all the changes.
And now it's going to run n mpm run
deploy. And this is again going to
actually use the Firebase command C
firebase CLI to go ahead and actually
deploy this. And we can actually see it
here in the shell command that the
deploy is complete. So now let's go
back.
Let me refresh our deployed one. And we
can actually now see that our links are
there.
&gt;&gt; So cool.
&gt;&gt; Greg, you remember to walk the dog.
&gt;&gt; And and folks, it's so tiny, but you can
see up in the the address bar, this is
local host or sorry, this is not local
host. This is deployed. [snorts]
&gt;&gt; Yeah. And again, people can go try this
out. If you're on the call, head over to
the link and you should now also be able
to kind of add different items and link
them together.
&gt;&gt; Yeah. And uh you deploy this on
Firebase. I think a lot of folks are
vibe coding stuff, then they get it
running locally and then they want to
share it with friends and they're not
really sure where to go from that. Could
you talk a little bit about uh why
Firebase makes for a good option for
deploying?
Yeah, for me Firebase is kind of for
anything that I want allin-one.
It's awesome, right? You can have your
database. I can have my website hosted
with Firebase web hosting. I can even
deploy things to cloud functions if I
want to. Uh it's basically prompting. I
just ask Gemini CLI, can you add, you
know, Google login authentication to the
site? It now knows who I am up here in
the top right corner. If you go to the
site yourself, it'll ask you to log in
to create your own like personal board
so that people can't see this. They see
their own memory wall when they join.
Um, and again, like this is just
prompting, right? And that Firebase has
a CLI, which because I have the Firebase
CLI
installed on my local machine, it means
Gemini CLI also has access to it, right?
The tools I have access to, Gemini CLI
has access to. So it knows how to
navigate them. It can kind of add things
to it can add databases to Firebase. It
can add the authentication all through
just leveraging the Firebase CLI. It
doesn't necessarily have to have all
that knowledge. Um it can kind of find
its way there.
&gt;&gt; I had this experience recently too and
um uh where I had not deployed to
Firebase before and was so impressed by
just installing the Firebase CLI
locally. Um, I think I maybe had to
authent uh and that was it. And then uh
and then just let Gemini CLI know that
the the Firebase CLI is there and then
when you get done with the thing, you
just say, "Hey, deploy this." And it
knows how to do it. And it just worked.
And uh really really uh it it feels like
it closes the loop on a lot of the VIP
coding stuff.
&gt;&gt; Totally.
&gt;&gt; Uh a couple other questions. Um
let's do this one. So, a lot of
excitement uh around anti-gravity as
well. There's obviously a lot of
intersection. Um how do you think about
when maybe someone might want to reach
for anti-gravity, when they might want
to reach for Gemini CLI?
&gt;&gt; Yeah, totally. Great question. um
they're really complimentary tools and
as we start to standardize on things
like skills, we mentioned having a
similar folder, we're really going to be
working hard to kind of making it so
that wherever you go, um your
[clears throat] processes, your plans,
your skills, maybe even your MCP
servers, like they can all follow you
between the two. I think right now kind
of
uh where I see anti-gravity being really
beneficial is like its agent manager
that kind of pain where you can
orchestrate different tasks uh in
parallel as well as it having the
ability to actually kind of have a
built-in version of kind of like
playright and chrome dev tools right so
it can actually spin up its own UI as
well take screenshots and validate so
things that we set up manually here in
Gemini CLI anti-gravity actually has
some of those features out of the box Um
whereas kind of Gemini CLI is more if
you're in the command line you're
wanting to kind of I almost say like
it's almost like a minimalistic mode
right so like we're just in the terminal
&gt;&gt; we're just sending commands checking in
on the progress um it's kind of kind of
a focused heads down
driven deployment whereas kind of
anti-gravity is more kind of a UI IDE
based but we've been this is the theme I
guess of this video it's always
preference so we're just going to do our
best to make it easy to kind of switch
between the two. In an ideal world, I
would love to see us get to the point
where I can create a plan and jump my
CLI, open anti-gravity and like iterate
iterate on the plan there or vice versa
to have the products really play nice
together. So, working towards that. I I
think it's so important too to just to
sort of double down on the personal
preference is to stress how incredibly
new this entire class of developer tools
is and um is so much of this is evolving
and also um is again just going to
depend on like what do you like doing
and what kind of projects are you
working on and so I strong plus one I
prefer working out of the CLI I find for
the stuff that I personally am working
on often are our simpler smaller
projects often green field projects and
I don't need to necessarily like to the
extent that I'm editing text a lot of
times I'm editing prompts or editing
commands or editing skills files or
whatnot as opposed to diving deep into
the code. So a lot of the IDE stuff is a
little superolous but a lot of folks are
are working on more complex stuff and
they they need to get in there with a
scalpel. Um, but I just I think it
varies so much from person to person and
it it would be um presumptive for anyone
to say, you know, here here's the the
matrix where if you have this, this, and
this, you definitely need this tool over
this one. Like, we're all sort of
figuring this stuff out as we go.
&gt;&gt; Yeah, it's it's total preference and
there's always going to be something
that someone likes better and your your
pal or colleague might like the other
one better, right? So just making sure
that you can do similar things in both I
think is kind of where we're working
towards.
&gt;&gt; Oh, looks like my uh camera died. So I
want to switch over real quick. But
that's probably a uh we'll switch to the
not as good one while we wrap up here.
Um so maybe that's a good time to uh
wrap this up. So folks who want to learn
more uh could you point us in the
direction of a few different resources?
&gt;&gt; Yeah, totally. We have a bunch of
different resources. is the
documentation is one that's great for if
you're looking to dive deep on a
specific feature or looking for the
reference documentation on how hooks
work, the different skills, how to go
about those. Um, if you're looking to
get started, you can check out last
week's live stream. We also have a
course in partnership with deep learning
that's totally free. That's like an hour
and a half that will walk through a lot
of the basics to get you comfortable
with, you know, context, uh, built-in
commands, MCP servers. you're like,
"Hey, how did he configure the Playright
MCP server?" Um, that course will walk
you through it um with some really fun
use cases. So, definitely check it out.
I think we'll link it below.
&gt;&gt; Yeah, a big plus one on that deep
learning course. You all did a great job
on that. And it's really accessible. I
think each of the chapters on it are
just like five, seven minutes. I mean,
it's so accessible, right?
&gt;&gt; Yeah, it's pretty quick. It's pretty
speedy. So, if you are having a few
minutes here and there, you can kind of
work your way through it within a week.
Yeah, I think course can feel the word
course can feel intimidating to folks,
but this is a very digestible, very very
accessible thing for folks who are just
getting up and running. And again, um,
you know, ask Gemini, ask like ask
Gemini CLI, like just get it installed
and start asking what it can do. It
knows a lot about itself, um, and can
really walk you through building stuff.
I think the the the best way analogy I
often use is like I picked up
woodworking and bought some power tools
and like I could watch all the YouTube
videos about circular saws that I wanted
to, but until I got some scrap wood and
started just like cutting some stuff
like you don't you're just going to
learn so much more there. Like read a
little bit so you don't cut your fingers
off. But like uh but at some point you
just got to start playing with it.
&gt;&gt; I agree. I think like for things some of
these concepts too like hooks it's kind
of like one of those things where it's
like why would I when would I use that?
Um, and it's really just actually
creating one like you could I was
actually brainstorming for this and
thinking of doing like a you know how
you have personal assistants or personal
coaches for working out like I was
thinking of making my own
&gt;&gt; you know Gemini CLI personal coach where
it's a hook and if I haven't committed
or haven't done things it will like on
startup kind of hey I don't see any
commits in your history the last two
days where you been or things like that
and that's all possible through hooks,
skills, extensions. So,
&gt;&gt; yeah, agreed. I think until you've
really um a lot of the follow on tools,
you know, whether it's custom commands,
hooks, um extensions, skills
were created in
uh sort of response to desires people
felt when using the standard tool. And
so the need for those might not make as
much sense to folks who have never used
them before, but that once you start
using them and and you build, you know,
vibe code something simple or whatnot,
then you'll start understanding better
like, oh yeah, it would be nice if I
could every time it was about to run RM.
I had like a a a hook that asked like,
"Hey, are you sure you want to do this?"
Right? Uh things like that. And um and
so yeah, once you just get your hands
dirty, I think it's absolutely the best
way to play with this stuff. Um any any
suggestions for folks on um you know if
they are just getting started uh how do
they do so in a way that feels really
safe to them? A lot of folks might feel
a little bit of uh anxiety over letting
the LLM run loose like uh what are some
best practices just for getting up and
running to make sure they don't you know
metaphorically cut off their fingers?
&gt;&gt; Yeah, I think starting in in the regular
mode or plan mode is your best kind of
best bet. Um be manually accepting all
the tool calls and confirmations. And
then we do have things like policy
engine where like
&gt;&gt; things like ls or certain commands that
you deem are safe. For instance, I have
like git status, git pull, like things
that are like really safe. You can add
those slowly and build up like a policy
file or like an allowed tools file where
it's kind of once you've gotten
comfortable and you don't want to have
those confirmations all the time.
potentially like bothering you, you
start adding those to that file and like
kind of like slowly kind of
understanding what you feel safe with.
Um, and I will do one final plug before
we wrap up here too that like
&gt;&gt; Gemini CLI is fully open source on
GitHub. The
&gt;&gt; code is all there right down to the
actual system prompts. So if you do feel
like, hey, I would love this feature in
Gemini CLI, go ahead, open a feature
request. uh and if you're feeling
adventurous and you want to like
contribute, we open it's open source and
we have external contributors like
hundreds of them uh contributing to the
project. So if that's something that
piques people's interests, definitely go
check out the GitHub. There's like a
help wanted label on issues that are
like good first ones to tackle or ones
that are like we're looking for
community help with. So I definitely
recommend people go check it out.
&gt;&gt; Incredible. And uh one one other place
where folks can uh learn about it is at
next uh which is happening in April.
We're gonna have um thousands and
thousands of developers there. We're
going to have a lot of talks and content
is going to be in Las Vegas at Mandalay
Bay. Um and uh you're going to be there,
right?
&gt;&gt; Yep. Yep. Most of the Gemini CLI team
will be there. So it's definitely a
place to check out.
&gt;&gt; All right. We are on track to sell out
that show. So, if you all are interested
in joining us in Vegas for uh for next
uh sign up ASAP. Um and uh we're going
to wrap it up here. Thank you all so
much for joining us for Google Cloud
Live. Uh next week Steph's going to be
back and talking to the anti-gravity
team. So, a lot of you had some awesome
questions about anti-gravity and uh if
you want to learn more about that, you
can join us at the same time next week.
And uh we will see you all then. Jack,
thank you so much for joining. This was
a lot of fun.
&gt;&gt; Thank you for having me.
hey, hey.
