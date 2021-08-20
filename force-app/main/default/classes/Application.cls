/*********************************************************************************
Class Name      : Application
Description     : Application framework, using the factory method 
				  defined fflib_Application to initialize each portion of the design pattern Apex enterprise
Created By      : Sebastian Torres
Created Date    : 2021-07-28
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------
Sebastian                 2021-07-28              Initial version
*********************************************************************************/
public class Application {
     
	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
		new fflib_Application.UnitOfWorkFactory(
				new List<SObjectType> { 
					Account.SObjectType, 
					Contact.SObjectType,
                    Opportunity.SObjectType,
                    agf__PPM_Project__c.SObjectType
                 });
				  	
   // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service = 
    new Application.ServiceFactory( 
         new Map<Type, Type> {
                IProjectsService.class => ProjectsServiceImpl.class });
                    
    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector = 
        new fflib_Application.SelectorFactory(
            // Map SObjectType to Selector Class
            new Map<SObjectType, Type> {
                    Account.SObjectType => AccountsSelector.class,
                    Contact.SObjectType => ContactsSelector.class,
                    Opportunity.SObjectType => OpportunitiesSelector.class,
                    agf__PPM_Project__c.SObjectType => ProjectsSelector.class }); 
                    
	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
		new fflib_Application.DomainFactory(
			Application.Selector,
			// Map SObjectType to Domain Class Constructors 
			new Map<SObjectType, Type> {
					/*Team__c.SObjectType => Teams.Constructor.class,
					Race__c.SObjectType => Races.Constructor.class,
					Car__c.SObjectType => Cars.Constructor.class,
					Driver__c.SObjectType => Drivers.Constructor.class,
            Contestant__c.SObjectType => Contestants.Constructor.class*/ });                    
           
    // Customised Service factory to support developer overrides via Custom Metadata (see Chapter 5)      
    private class ServiceFactory extends fflib_Application.ServiceFactory {
        
        private Map<String, String> servicesByClassName = new Map<String, String>();
        
        public ServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType) {
            super(serviceInterfaceTypeByServiceImplType);
            
            // Map of overriden services defined by the developer in this org
            /*
            for(Service__mdt serviceOverride : 
                    [select DeveloperName, NamespacePrefix, ApexClass__c from Service__mdt]) {
                servicesByClassName.put(
                    serviceOverride.NamespacePrefix + '.' + serviceOverride.DeveloperName, 
                    serviceOverride.ApexClass__c);                
            }*/
        }
        
        public override Object newInstance(Type serviceInterfaceType) {
            
            // Has the developer overriden the Service implementaiton in their org?
            if(!Test.isRunningTest() && servicesByClassName.containsKey(serviceInterfaceType.getName())) {
                String overridenServiceImpl = servicesByClassName.get(serviceInterfaceType.getName());
                return Type.forName(overridenServiceImpl).newInstance();
            }
            
            // Default Service Factory returns mocked or registered default implementation
            return super.newInstance(serviceInterfaceType);    
        }        
    }
    
    /**
     * Utility method to throw Application exceptions to Lightning Components
     **/
    public static void throwAuraHandledException(Exception e) {
        String message = e.getMessage();
        AuraHandledException error = new AuraHandledException(message);
        error.setMessage(message); // Ensure Apex tests can assert the error message value
        throw error;
    }
}