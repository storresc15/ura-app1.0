@IsTest
public class UserService_Test {
  @isTest
  static void whenactivateUserFromContactIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(
      fflib_SObjectUnitOfWork.class
    );
    ContactsSelector mockContactSelector = (ContactsSelector) mocks.mock(
      ContactsSelector.class
    );
    UsersSelector mockUserSelector = (UsersSelector) mocks.mock(
      UsersSelector.class
    );
    Users mockDomain = (Users) mocks.mock(Users.class);

    //Given - Configure mock responses
    Id ContactId = fflib_IDGenerator.generate(Contact.SObjectType);
    Id UserId = fflib_IDGenerator.generate(User.SObjectType);
    /*List<Contact> testUsersAndContacts = (List<Contact>) fflib_ApexMocksUtils.makeRelationship(List<Contact>.class,
                                                                                             new List<Contact>{new Contact(id = ContactId)},
                                                                                             User.ContactId,
                                                                                             new List<List<User>> {
                                                                                                 new List<User> {
                                                                                                     New User (Id = UserId)
                                                                                                 } });*/
    List<Contact> testContacts = new List<Contact>{
      new Contact(id = ContactId)
    };
    List<User> testUsers = new List<User>{ new User(id = UserId) };

    mocks.startStubbing();
    mocks.when(mockContactSelector.SObjectType())
      .thenReturn(Contact.SObjectType);
    mocks.when(mockContactSelector.selectById(new Set<id>{ ContactId }))
      .thenReturn(testContacts);
    mocks.when(mockUserSelector.SObjectType()).thenReturn(User.SObjectType);
    mocks.when(mockUserSelector.selectByContactId(new Set<id>{ ContactId }))
      .thenReturn(testUsers);
    mocks.when(mockDomain.SObjectType()).thenReturn(User.SObjectType);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockContactSelector);
    Application.Domain.setMock((fflib_ISObjectDomain) mockDomain);

    //When
    UserService.activateUserFromContact(new Set<Id>{ ContactId });
    ((ContactsSelector) mocks.verify(mockContactSelector, 0))
      .selectById(new Set<Id>{ ContactId });
    ((Users) mocks.verify(mockDomain, 0))
      .activateUser(new User(id = UserId), mockUow);
    ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, 1)).commitWOrk();
  }

  @isTest
  static void whenDeactivateUserFromContactIsCalled() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    //Given - Create Mocks
    fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(
      fflib_SObjectUnitOfWork.class
    );
    ContactsSelector mockContactSelector = (ContactsSelector) mocks.mock(
      ContactsSelector.class
    );
    UsersSelector mockUserSelector = (UsersSelector) mocks.mock(
      UsersSelector.class
    );
    Users mockDomain = (Users) mocks.mock(Users.class);

    //Given - Configure mock responses
    Id ContactId = fflib_IDGenerator.generate(Contact.SObjectType);
    Id UserId = fflib_IDGenerator.generate(User.SObjectType);
    List<Contact> testUsersAndContacts = (List<Contact>) fflib_ApexMocksUtils.makeRelationship(
      List<Contact>.class,
      new List<Contact>{ new Contact(id = ContactId) },
      User.ContactId,
      new List<List<User>>{ new List<User>{ new User(Id = UserId) } }
    );
    List<Contact> testContacts = new List<Contact>{
      new Contact(id = ContactId)
    };
    List<User> testUsers = new List<User>{ new User(id = UserId) };

    mocks.startStubbing();
    mocks.when(mockContactSelector.SObjectType())
      .thenReturn(Contact.SObjectType);
    mocks.when(mockContactSelector.selectById(new Set<id>{ ContactId }))
      .thenReturn(testContacts);
    mocks.when(mockUserSelector.SObjectType()).thenReturn(User.SObjectType);
    mocks.when(mockUserSelector.selectByContactId(new Set<id>{ ContactId }))
      .thenReturn(testUsers);
    mocks.when(mockDomain.SObjectType()).thenReturn(User.SObjectType);
    mocks.stopStubbing();

    //Given - Inject Mocks
    Application.UnitOfWork.setMock(mockUow);
    Application.Selector.setMock(mockContactSelector);
    Application.Domain.setMock((fflib_ISObjectDomain) mockDomain);

    //When
    UserService.deactivateUserFromContact(new Set<Id>{ ContactId });
    ((ContactsSelector) mocks.verify(mockContactSelector, 0))
      .selectById(new Set<Id>{ ContactId });
    ((Users) mocks.verify(mockDomain, 0))
      .activateUser(new User(id = UserId), mockUow);
    ((fflib_SObjectUnitOfWork) mocks.verify(mockUow, 1)).commitWOrk();
  }
}
