<link href="./theme/style.css" rel="stylesheet"></link>

# Procedural to Object-Oriented Modules

Note: Welcome to Procedural to Object-Oriented Modules

---

## Who am I?

* Cameron Zemek (grom@pnx.me)
* Senior Drupal Developer at PreviousNext
* Username (drupal, github, twitter): grom358
* 10 years in PHP
* Using drupal since version 4

Note: My name is Cameron Zemek, and I am a senior drupal developer at PreviousNext.
I have been working in PHP for almost 10 years now, and been using drupal since version 4. Recently have I become more heavily involved in the drupal community. And I really excited for the future of Drupal with its move towards OO.

---

## Getting off the island

![Island](./images/island.jpg "Getting off the island")

Note: So Drupal 8 is making major architectural changes with a shift from procedural to OO and taking advantage of PHP 5.4 and many excellent external libraries.
This means less drupalisms with Drupal 8, or as I like to put it. We moving off the drupal island and heading to the PHP mainland. We are becoming a part of the larger PHP community and avoiding reinvention of the wheel.
We are also contributing back to these projects and improving the PHP landscape for everyone.

---

## But don't be afraid

![Don't be afraid](./images/cthulhu.jpg "Don't be afraid")

> If you learnt php from Drupal - Drupal 8 will teach you modern php from a familiar setting. (Lee Rowlands, 2014)

Note: But don't be afraid. For those that are not as familiar and as experienced with OO and grew up in drupal this change may seem daunting.
But as fellow drupaler Lee Rowlands said, learning drupal 8 will teach you modern PHP from a familiar setting.
In this session we are going to look at some examples of how we can refactor from procedural modules into object-oriented modules to ease your fear.

---

## Why Object-Oriented

![Object Oriented](./images/object-oriented.jpg "Object Oriented")

Note: Before we go into that, you may be wondering what the big deal is, and why drupal is making this change.
In my opinion it is making Drupal better designed and easier to develop for. For example, instead of arrays (like form arrays and render arrays) where you have to memorize what the keys are or look up the documentation. We now have interfaces.
An interface defines a contract for how we interact with a component and its more visible and better supported by tools such as an IDE.
For example, an IDE doesn't know we are working with a form array and what keys are valid, but with objects it gives us autocompletion of what methods exist on it. So interfaces are a lot easier to work with.
Additionally interfaces gives us pluggable components. We are abstracted from a concrete implementation and we are free to provide alternative implementations. For example, menu storage is currently using a tree structure, we could swap that out to using an implementation based on nested set theory if we wanted.
This swappability also helps with testing, as we can use a test double or what is referred to as a mock object in place of the real object. But more on testing later.
With this change to OO we are also seeing a better separation of concerns. Drupal 8 is no longer assuming the output is HTML and is better supporting web services and other output formats.
The change to OO is also taking advantage of established design patterns and principles. Learning one part of drupal applies to many areas of drupal 8 and even to other PHP projects. So now its quicker for non drupal developers to get started on drupal and likewise for drupal developers to contribute to other projects. That is there is more familiarity between PHP projects.

---

## Switch Witch

```
<?php
function example_block_info() {
  $blocks = array();
  $blocks['test-block'] = array(
    'info' => t('Test block'),
  );
  $blocks['another-test-block'] = array(
    'info' => t('Another test block'),
  );
  return $blocks;
}

function example_block_view($delta = '') {
  $block = array();
  switch ($delta) {
    case 'test-block':
      $block['subject'] = t('My test block');
      $block['content'] = t('An example block');
      break;
    case 'another-test-block':
      $block['subject'] = t('Yet another block');
      $block['content'] = t('Just a block');
      break;
  }
  return $block;
}
```

Note: Okay so lets start by looking at an example of a drupal 7 module that is defining some blocks.
First thing to note is this Drupalism of hooks. With hooks we have to be careful in the naming of our functions so they match the required hook and that the arguments align with how drupal will call our hook.
If we make a mistake with the function signature there is no immediate feedback.
Second thing to notice is we have these switch statements over delta where the case statements have to match the id returned in the info function.
So here I have only defined the view hook, but if I was to add in say configuration form hooks we would have similiar looking switch statements.

So the problem with this is it tends to lend to this massive switch statements, especially as we add more and more blocks to our module. Also if we want to see everything relating to a single block we have to check for any hooks relating to blocks, and then skim over these switch statements looking for the case that matches the delta of the block we are interested in.
Now lets take compare to the object-oriented module in Drupal 8.

---

## Objects to the rescue

```
<?php
// Defined by core block module
interface BlockPluginInterface {
  public function label();
  public function build();
  // Other methods omitted for brevity.
}

abstract class BlockBase extends ContextAwarePluginBase
  implements BlockPluginInterface {
  // Omitted for brevity.
}

// Our module code
/**
 * @Block(
 *   id = "example_block",
 *   subject = @Translation("Example block"),
 *   admin_label = @Translation("Example Block")
 * )
 */
class ExampleBlock extends BlockBase {
 public function build() {
   return $this->t('An example block');
 }
}
```

Note: So defined by core we have a block interface instead of hooks. The advantage of this is it more clearly defines what methods exist for blocks. We no longer have to search the api for hook_block, we can just go to the interface and look at its methods.
In this code snippet I've omitted methods on the block plugin interface such as methods for configuration forms. So a block might not even need a configuration form, so Drupal core provides an abstract base class that implements a default implementation of the interface. So then in our module code we can just extends this base class and only implement the methods of the interface that we need.
So unlike with hooks, with IDE we get immediate feedback that we are implementing a method from the interface and its signature is correct. We can also easily find blocks in the system using find usages. And compared to drupal 7 we have everything relating to an individual block grouped into a single class in its own file, and so we can find our blocks and see what blocks exist at the filesystem level.

---

## Bridging the gap

* Drupal 8 Now Series - http://www.previousnext.com.au/blog/drupal-8-now-writing-drupal-7-code-eye-towards-drupal-8
* https://www.drupal.org/project/ghost

```
<?php
$plugin = array(
  'title' => t('Example block'),
  'description' => t('An example block'),
  'class' => 'Drupal\ghost_examples\Block\BlockPluginExample',
);

class BlockPluginExample extends BlockPluginBase {
  public function blockInfo() {
    return array(
      'info' => t('Example block'),
    );
  }
 
  public function blockSubject() {
    return t('My test block');
  }
 
  public function blockContent() {
    return t('An example block');
  }
}
```

Note: The OO example I just gave was of drupal 8. So the question is can we use object-oriented modules in drupal 7 that will be sympathetic to Drupal 8. That is porting the module will be more straightforward and better fit drupal 8.
The short answer is yes. Chris Skene from PreviousNext has recently published a module on drupal.org called Ghost that lets you use object-oriented pages, forms and blocks in Drupal 7.
On this slide is an example of a block using Ghost, which is similiar to the approach in drupal 8 and so is more sympathetic to porting.
If you check out the Drupal 8 Now blog series on PreviousNext, there is more information on briding the gap between 7 and 8 with your modules.

---

## SOLID

* Single responsibility principle
* Open/closed principle
* Liskov substitution principle
* Interface segregation principle
* Dependency Inversion principle

Note:
So the block example we just looked at is a basic example of using OO. Our aim is to create a system that is easy to maintain and extend over time. In order to help with that we can use a number of principles and patterns as guidelines when creating OO modules. One such set of principles has been coined with the acronym SOLID.
The single responsibility principle states that every context (eg. a class, function or variable) should have a single responsibility, and that responsibility should be entirely encapsulated by the context.
The open/closed principle states that "software entities (eg. a class) should be open for extension, but closed for modification." That is it should allow its behaviour to be modified without altering its source code, such as using plugins or drivers.
Liskov substituation principle states that objects should be replaceable with instances that are subtypes without altering the correctness of the program. That is subclasses or implementations of an interface should be interchangable.
Interface segregation principle states that no client should be forced to depend on methods it does not use. So the principle is to prefer smaller and more specific interfaces to larger ones.
The Dependency Inversion principle states that we should depend on abstractions (that is interfaces) and not specific implementations (that is classes).

---

## Design Patterns

![Pattern](./images/pattern.jpg "Pattern")

Note: In addition to the SOLID principles there are design patterns which we can also apply with OO. So what are design patterns?
A design pattern is a general reusable solution to a commonly occurring problem within a given context in software design.
The solution isn't a concrete implementation but a description or template on how to solve a problem that can be used in different situations.
These design patterns are not specific to Drupal and are common to many object-oriented langauges besides php.
So with Drupal 8 we use a number of these common design patterns and therefore there are less drupalisms. With the idea being once you learn something in Drupal 8 you can apply it in multiple situations and projects.
So lets look at some of these design patterns and how they can be applied to our modules.

---

## Dependency Injection

![Dependency Injection](./images/injection.jpg "Dependency Injection")

Note: Dependency injection is a software design pattern in which one or more dependencies are injected into a client object and are made part of the client's state. Its one method of following the Dependency Inversion principle.
It separates the creation of a client's dependencies from its own behavior, which allows for loose coupling and helps to keep the class having a single reponsibility.
This improves flexibility and testability because we can use swap the dependency. For example we use this in unit testing to use mock objects for the dependencies.

---

## Dependency Injection

```
<?php
class ClientExample {
  protected $database;

  public function __construct(ConnectionInterface $database) {
    $this->database = $database;
  }

  public function someMethod() {
    $data = $this->database->query("SELECT myfield FROM mytable")->fetchCol();
    // perform calculation on data
    return $result;
  }
}
```

Note: So a classic example is we require a database connection. In the code here we inject the dependency by having the constructor have the dependency as an argument.
This allows us when testing to replace the normal connection with one to test database or better yet, a mock connection that doesn't implement a connection to database at all, but returns the data needed for the test. In this case doing this allows us to test the calculation logic in isolation and not test the dependent component of the database. This gives us greater confidence that the calculation logic is correct as we are not dependent on state from the database.

---

## Factory Pattern 

![Factory](./images/factory.jpg "Factory")

Note: Next we have the factory pattern. In class based languages such as php, a factory is the abstraction for the creation of an object. Using a constructor results in an object of concrete class, so by having our dependent class using the new keyword to create the class it becomes coupled with that specific class and also has responsibility to creation of that object which is outside its own behaviour. By using the factory pattern we can decouple from using concrete classes as now its the factory's responsibility.

---

## Factory Pattern

```
<?php
// Without factory pattern
class ClientExample {
  public function __construct() {
    // Client is reponsible for creation of the dependency
    // which is outside defining its own responsibility.
    $arg = 'some value';
    $anotherArg = new DependencyOfOurDependency();
    $this->dependency = new SomeDependency($arg, $anotherArg);
  }
}

// With factory pattern
class ClientExample {
  public function __construct() {
    $this->dependency = SomeDependency::create();
  }
}
```

Note: So in this example we compare the code before and after we applied the factory pattern. Without the factory the responsibility for the creation of the dependency is part of our class which muddles our class with responsibility besides its own behaviour. With the factory pattern we have moved the responsibility to the class that is better able to handle it and maintain the single responsibility principle and dependency inversion principle.

---

## Factory in Drupal

```
<?php
class BlockContentForm extends ContentEntityForm {
  public function __construct(
    EntityManagerInterface $entity_manager,
    EntityStorageInterface $block_content_storage,
    LanguageManager $language_manage
  ) {
    parent::__construct($entity_manager);
    $this->blockContentStorage = $block_content_storage;
    $this->languageManager = $language_manager;
  }

  public static function create(ContainerInterface $container) {
    $entity_manager = $container->get('entity.manager');
    return new static(
      $entity_manager,
      $entity_manager->getStorage('block_content'),
      $container->get('language_manager')
    );
  }
}
```

Note: In this Drupal 8 code here we using a factory method in conjunction with dependency injection. Notice the factory method takes a ContainerInterface. The container is responsible for the assembly of objects and is controlled via YAML configuration files.

---

## Container

```
services:
  module_handler:
    class: Drupal\Core\Extension\ModuleHandler
    arguments: ['%container.modules%', '@cache.bootstrap']
  entity.manager:
    class: Drupal\Core\Entity\EntityManager
    arguments: [
      '@container.namespaces',
      '@module_handler',
      '@cache.discovery',
      '@language_manager',
      '@string_translation',
      '@class_resolver',
      '@typed_data_manager'
    ]
    parent: container.trait
    tags:
      - { name: plugin_manager_cache_clear }
```

Note: Here we define module_handler and entity.manager and what class to construct and the dependencies arguments to pass to them.

---

## Mediator pattern

* Drupal 8 event system follows this pattern http://goo.gl/3uPKMx

![Event System](./images/events.png "Event System")

Note: Another pattern you will see in Drupal 8 is the Mediator pattern.
The essence of the Mediator Pattern is to "Define an object that encapsulates how a set of objects interact"
With this pattern, communication between objects is encapsulated with a mediator object. Objects no longer communicate directly with each other, but instead communicate through the mediator. This reduces the dependencies and coupling between communicating objects, as they no longer need to be aware of each other only of the mediator.
In Drupal 8 the event system is an example of the mediator pattern in action. Classes that generate events are seperate from classes that interact on these events through the EventDispatcher.
We register interest in events by implementing the EventSubscriberInterface which has the getSubscribedEvents method that returns the events we are interested in and the callback to call when those events occur.
So in this sequence diagram we have CurrentUserContext and NodeRouteContext subscribing to BlockConditionContextEvents.
Then BlockBase dispatches these events to the EventDispatcher which then takes care of notifying these subscribers.

---

## Unit testing

![Testing](./images/testing.jpg "Testing")
  
Note: The general theme of these design patterns is that they are reducing coupling. This really helps with testibility and therefore improves quality as we can test and verify each part in isolation.
By writing unit tests we gain a strict written contract that the part must satisfy. We have a repeatable and provable set of functionality which provides a number of benefits.
Unit tests should be ran frequently and since they testing individual part we detect errors at early stage.
And with this repeatable test suite it opens up the possibility to refactor code and check that the module still works correctly.
It simplifies integration as we reduce uncertainty with the invidiual parts and so integration testing becomes much easier since there is less surface area that is untested.
Unit tests act as a sort of living documentation. It is always in sync with the functionality of the code and it describes in detail the functionality that is provided.
The process of creating unit tests also helps improve our design. For when something is difficult to test it means our design most likely needs improving. That is we have a design smell. So the unit tests drives us to use better designs so the code is testable.

---

## Mocking

![Mocking](./images/mock.jpg "Mocking")

Note: Objects may have a number of dependencies so the question is how can we test it in isolation. As you probably can guess, the answer is we use a mock object that simulates the behavior of real objects in a controlled way. This is in much the same way that car designers use a crash test dummy to simulate vehicle impacts.
Mock objects are useful when the dependency has any number of characteristics such as:
* Its results are non-deterministic (eg. the current temperature)
* It has states that are difficult to create or reproduce (eg. a network error)
* It is slow (eg. a database)
* It does not exist yet

---

## Mocking

```
<?php
class AlarmTest extends PHPUnit_Framework_TestCase {
  public function testRadioWakeup() {
    $stub = $this->getMock('Clock');
    $stub->method('getCurrentTime')
      ->willReturn(Time::fromString('6:00 AM'));

    $alarmClock = new AlarmClock($stub);
    $alarmClock->setAlarmFor(Time::fromString('6:00 AM'));

    $this->assertTrue($alarmClock->isWakeup());
    $this->assertTrue($alarmClock->isRadioPlaying());
  }
}
```

Note: For example, an alarm clock which causes the radio to start playing at a certain time. We don't want to only be able to test if this is working once a day or by having to change the time on the clock to test the alarm works. So what we do is we have a mock object for the Clock object that returns the time of the alarm. In this way we simulate the conditions required for the alarm. Then we assert that the radio should be playing.

This improves quality and development speed as we have a faster feedback loop on wether a part is working on not. We don't have to ship the alarm clocks to users for testing to find out the alarm doesn't work.

---

## Important Changes in Drupal 8

* http://www.previousnext.com.au/blog/drupal-south-presentation-everything-you-wanted-know-about-drupal-8-were-too-afraid-ask
* Utility class methods in preference to functions. Eg. String::checkPlain instead of check_plain
* hook_menu is gone, replaced by routes
* variable_set / variable_get is replaced with a configuration system

```
<?php
$config = \Drupal::config('forum.settings');
$vocabulary = $config->get('vocabulary');
$config->set('vocabulary', 'hooha')->save();
```

Note: There are lot of changes with Drupal 8 and unfortunately we don't have time to cover them in this session. If you want to know more about the changes I highly recommend the talk 'Everything you wanted to know about Drupal 8 but were too afraid to ask' by Lee Rowlands and Kim Pepper.
However I will cover a couple of the changes here briefly. Firstly there is a preference to use utility class methods instead of utility functions. For example check plain is now a method of the String utility class. Basically there is less population of the global namespace in Drupal 8. Its still a work in progress however, Drupal 8 is a procedural object-oriented hybrid but expect to see less procedural as we move to Drupal 9. That is object-oriented programming in the future of Drupal.
Probably the biggest change that will affect your modules is hook_menu is gone and been replaced by routes. And variable_set and get have been replaced with a proper configuration system.

---

## Routing Pages

```
<?php
namespace Drupal\page_example\Controller;

use Drupal\Core\Controller\ControllerBase;

class PageExampleController extends ControllerBase {
  public function pageExample() {
    return array(
      '#markup' => $this->t('This is some content'),
    );
  }
}

// yaml config file
page_example.example:
  path: 'examples/page_example'
  defaults:
    _content: '\Drupal\page_example\Controller\PageExampleController::pageExample'
  requirements:
    _permission: 'access examples'
```

Note: So we use routes in Drupal 8 to create pages in two easy steps. First we create our page controller by extending ControllerBase. Then second we create our route definition in a YAML configuration file.

Similiar to the block example from earlier procedural functions have been replaced with objects. Here we have our controller class extending ControllerBase where the method defined our page.
Another quick note here. Functions such as translation function are now methods on the ControllerBase. So we have $this->t instead of calling the global t function.

Then we define our route in a YAML configuration file.
The route has an id page_example.example and defines the path for the page and the method that creates the page.
By using an id for the route the code is not dependent on the path, this lets us hot-swap paths. One of the many benefits to the new route system.
If you want to find out more about how to replace hook_menu, I again recommend that you check out Lee and Kim's talk.

---

## Drupal Module Upgrader

* https://www.drupal.org/project/drupalmoduleupgrader

Note: With all these changes to Drupal 8, thankfully there are some tools to help in the process. One such tool is Drupal Module Upgrader developed by Acquia. It will help detect old drupal 7 code and flag errors that point to the relevant change notices. The goal being to detect the most widely-used hooks and give you information about them.

---

## Pharborist

* http://www.previousnext.com.au/blog/dom-php
* Provides a jQuery insipired library for PHP source trees
* Example usages:
  * Drupal Module Upgrader https://www.drupal.org/node/2319353#comment-9059853
  * Conversion of procedural function calls to utility function https://github.com/grom358/d8codetools
  * Array syntax upgrade http://www.previousnext.com.au/blog/upgrade-array-syntax-automatic-way

Note: Another tool that you may find useful is one I have developed called Pharborist. Its a library that provides a jQuery inspired interface for working with PHP source trees. Its still in its infancy but I would like to see tools like Drupal Module Upgrader and php-cs fixer using it in the future.
So far its been used to create a number of patches to convert procedural function calls to the class utility method. Eg. check_plain patch was created by the tool I have on github there.
I have also blogged showing an example of using it to upgrade from old array syntax to the new style.


---

## Pharborist

```
<?php
$tree = Parser::parseFile($filename);
foreach ($tree->find(Filter::isInstanceOf('\Pharborist\ArrayNode')) as $array) {
  // Test if using old syntax.
  if ($array->firstChild()->getText() === 'array') {
    // Remove any hidden tokens between T_ARRAY and ( .
    $array->firstChild()->nextUntil(function (Node $node) {
      return $node instanceof TokenNode && $node->getType() === '(';
    })->remove();
    // remove T_ARRAY token.
    $array->firstChild()->remove();
    // replace ( with [ .
    $array->firstChild()->replaceWith(Token::openBracket());
    // replace ) with ] .
    $array->lastChild()->replaceWith(Token::closeBracket());
  }
}
```

Note: Here is snippet of the code from that blog to show you Pharborist in action. The PHP source is constructed into a tree which can then navigate via jQuery like methods. So we find arrays in the tree and foreach one we test if its in the old syntax and if so we convert it into the new syntax.
Its still rather early days for this library so shamelessly plugging it here, hoping to gain some more interest and feedback on it.

---

## Special Thanks

Special thank you to the following people from PreviousNext:

* Kim Pepper (Technical Director)
* Lee Rowlands (Senior Drupal Developer)
* Nick Schuch (Web Developer / Sysadmin)
* Chris Skene (Drupal Consultant)

---

## Questions

---

## Contact

* Cameron Zemek
* Email: grom@pnx.me
* Drupal: grom358
* Twitter: grom358