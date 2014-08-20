/*
 * JBoss, Home of Professional Open Source
 * Copyright 2014, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the 
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,  
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.quickstarts.brms;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.BeforeClass;
import org.junit.Test;
import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.StatelessKieSession;

//added for Teiid
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
//added for Teiid
import org.teiid.jdbc.TeiidDataSource;
import org.teiid.jdbc.TeiidStatement;

/**
 * @author rafaelbenevides
 * 
 */
public class HelloWorldBRMSTest {

    private static StatelessKieSession kSession;

    // A sale for a VIP customer
    private static Sale vipSale;
    // A sale for a regular customer
    private static Sale regularSale;
    // A sale for a Bad customer
    private static Sale badSale;

    @BeforeClass
    public static void setup() {

	KieServices kieServices = KieServices.Factory.get();
        KieContainer kContainer = kieServices.getKieClasspathContainer();
        kSession = kContainer.newStatelessKieSession();
	//added for Teiid to get data from text and xml files
	System.out.println("== Using DV to pull federated data then execute rules ==============");
	String url = "jdbc:teiid:CustomerContextVDB@mm://localhost:31000";
	String sql = "select CustomerID, CustomerName, CustomerCreditScore, CustomerSentiment, CustomerCalls from CustomerContext";
	Connection connection = null;
	try {
		Class.forName("org.teiid.jdbc.TeiidDriver");
		connection=DriverManager.getConnection(url,"user","user");
		Statement statement = connection.createStatement();
		ResultSet results=statement.executeQuery(sql);
		int i=0;
		CustomerType ctype = new CustomerType();
		Customer customer = new Customer();
		Sale sale = new Sale();
		String type = "regular";
		String customerid, customername,customercreditscore,customersentiment,customercalls = "";
		while (results.next()) {
			customerid=results.getString(1);
			customername=results.getString(2);
			customercreditscore=results.getString(3);
			customersentiment=results.getString(4);
			customercalls=results.getString(5);
			System.out.println("Customer "+(++i)+" "+customerid+" "+customername+" "+customercreditscore+" "+customersentiment+" "+customercalls);
			type = "regular";
			//these rules could be moved to BRMS
			if (customersentiment.equals("Hot")) type = "VIP";
			if (Integer.parseInt(customercreditscore) < 500) type = "BAD";
			if (Integer.parseInt(customercalls) > 5) type = "VIP";
			//end of the customer definition rules of regular, VIP, BAD
			ctype.setType(type);
			customer.setCustomerType(ctype);
			sale.setCustomer(customer);
			System.out.println("** Testing Customer "+i+" **");
			kSession.execute(sale);
			
		}
		results.close();
		statement.close();
		System.out.println("=========================================================================");
	}
	catch (SQLException e) {
		e.printStackTrace();
	}
	
	catch (Exception e2) {
		e2.printStackTrace();
	}
	finally {
		try {
			connection.close();
		} catch (SQLException el) {
			el.printStackTrace();
		} catch (Exception e3) {
			e3.printStackTrace();
		}
	}
	System.out.println("== Now running original quickstart ==============");
        CustomerType regular = new CustomerType();
        regular.setType("regular");

        CustomerType vip = new CustomerType();
        vip.setType("VIP");
        
        CustomerType bad = new CustomerType();
        bad.setType("BAD");

        Customer vipCustomer = new Customer();
        vipCustomer.setCustomerType(vip);
        vipSale = new Sale();
        vipSale.setCustomer(vipCustomer);

        Customer regularCustomer = new Customer();
        regularCustomer.setCustomerType(regular);
        regularSale = new Sale();
        regularSale.setCustomer(regularCustomer);

        Customer badCustomer = new Customer();
        badCustomer.setCustomerType(bad);
        badSale = new Sale();
        badSale.setCustomer(badCustomer);
    }

    @Test
    public void testGoodCustomer() {
        System.out.println("** Testing VIP customer **");
        kSession.execute(vipSale);
        // Sale approved
        assertTrue(vipSale.getApproved().booleanValue());
        // Discount of 0.5
        assertEquals(vipSale.getDiscount(), 0.50F, 0.0);
    }
    
    @Test
    public void testRegularCustomer() {
        System.out.println("** Testing regular customer **");
        kSession.execute(regularSale);
        // Sale approved
        assertTrue(regularSale.getApproved().booleanValue());
        // No Discount
        assertNull(regularSale.getDiscount());
    }

    @Test
    public void testBadCustomer() {
        System.out.println("** Testing BAD customer **");
        kSession.execute(badSale);
        // Sale denied
        assertFalse(badSale.getApproved().booleanValue());
    }

}
