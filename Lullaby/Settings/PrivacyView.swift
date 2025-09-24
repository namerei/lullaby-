//
//  PrivacyView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 08/05/24.
//

import SwiftUI

struct PrivacyView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Group { // Header
                    Text("Privacy Policy")
                        .font(.largeTitle.bold())
                    Text("Owner and Data Controller")
                        .font(.title)
                    Text("**Owner contact email:** `Krutov89@bk.ru`")
                }
                Group { // Types of Data collected
                    Text("Types of Data collected")
                        .font(.title)
                    Text("Among the types of Personal Data that this Application collects, by itself or through third parties, there are: Cookies; Usage Data; unique device identifiers for advertising (Google Advertiser ID or IDFA, for example); email address; device information; geography/region; number of Users ; number of sessions; session duration; In-app purchases; Application opens; Application updates; first launches; operating systems; first name; last name.")
                    Text("Complete details on each type of Personal Data collected are provided in the dedicated sections of this privacy policy or by specific explanation texts displayed prior to the Data collection.")
                    Text("Personal Data may be freely provided by the User, or, in case of Usage Data, collected automatically when using this Application.")
                    Text("Unless specified otherwise, all Data requested by this Application is mandatory and failure to provide this Data may make it impossible for this Application to provide its services. In cases where this Application specifically states that some Data is not mandatory, Users are free not to communicate this Data without consequences to the availability or the functioning of the Service.")
                    Text("Users who are uncertain about which Personal Data is mandatory are welcome to contact the Owner.")
                    Text("Any use of Cookies – or of other tracking tools – by this Application or by the owners of third-party services used by this Application serves the purpose of providing the Service required by the User, in addition to any other purposes described in the present document and in the Cookie Policy, if available.")
                    Text("Users are responsible for any third-party Personal Data obtained, published or shared through this Application and confirm that they have the third party's consent to provide the Data to the Owner.")
                }
                .fontWeight(.light)
                Group {
                    Text("Mode and place of processing the Data")
                        .font(.title)
                    Text("Methods of processing")
                        .font(.title2)
                    Text("The Owner takes appropriate security measures to prevent unauthorized access, disclosure, modification, or unauthorized destruction of the Data")
                    Text("The Data processing is carried out using computers and/or IT enabled tools, following organizational procedures and modes strictly related to the purposes indicated. In addition to the Owner, in some cases, the Data may be accessible to certain types of persons in charge, involved with the operation of this Application (administration, sales, marketing, legal, system administration) or external parties (such as third-party technical service providers, mail carriers, hosting providers, IT companies, communications agencies) appointed, if necessary, as Data Processors by the Owner. The updated list of these parties may be requested from the Owner at any time.")
                    Text("Legal basis of processing")
                        .font(.title2)
                    Text("The Owner may process Personal Data relating to Users if one of the following applies:\n- Users have given their consent for one or more specific purposes. Note: Under some legislations the Owner may be allowed to process Personal Data until the User objects to such processing (“opt-out”), without having to rely on consent or any other of the following legal bases. This, however, does not apply, whenever the processing of Personal Data is subject to European data protection law\n- provision of Data is necessary for the performance of an agreement with the User and/or for any pre-contractual obligations thereof\n- processing is necessary for compliance with a legal obligation to which the Owner is subject\n- processing is related to a task that is carried out in the public interest or in the exercise of official authority vested in the Owner\n- processing is necessary for the purposes of the legitimate interests pursued by the Owner or by a third party")
                    Text("In any case, the Owner will gladly help to clarify the specific legal basis that applies to the processing, and in particular whether the provision of Personal Data is a statutory or contractual requirement, or a requirement necessary to enter into a contract")
                }
                .fontWeight(.light)
                Group { // Place
                    Text("Place")
                        .font(.title)
                    Text("The Data is processed at the Owner's operating offices and in any other places where the parties involved in the processing are located")
                    Text("Depending on the User's location, data transfers may involve transferring the User's Data to a country other than their own. To find out more about the place of processing of such transferred Data, Users can check the section containing details about the processing of Personal Data")
                    Text("Users are also entitled to learn about the legal basis of Data transfers to a country outside the European Union or to any international organization governed by public international law or set up by two or more countries, such as the UN, and about the security measures taken by the Owner to safeguard their Data")
                    Text("If any such transfer takes place, Users can find out more by checking the relevant sections of this document or inquire with the Owner using the information provided in the contact section")
                }
                .fontWeight(.light)
                Group { // Retention Time & Purposes
                    Text("Retention TIme")
                        .font(.title)
                    Text("Personal Data shall be processed and stored for as long as required by the purpose they have been collected for")
                    Text("Therefore:\n- Personal Data collected for purposes related to the performance of a contract between the Owner and the User shall be retained until such contract has been fully performed\n- Personal Data collected for the purposes of the Owner’s legitimate interests shall be retained as long as needed to fulfill such purposes. Users may find specific information regarding the legitimate interests pursued by the Owner within the relevant sections of this document or by contacting the Owner")
                    Text("The Owner may be allowed to retain Personal Data for a longer period whenever the User has given consent to such processing, as long as such consent is not withdrawn. Furthermore, the Owner may be obliged to retain Personal Data for a longer period whenever required to do so for the performance of a legal obligation or upon order of an authority")
                    Text("Once the retention period expires, Personal Data shall be deleted. Therefore, the right to access, the right to erasure, the right to rectification and the right to data portability cannot be enforced after expiration of the retention period")
                    Text("The purposes of processing")
                        .font(.title)
                    Text("The Data concerning the User is collected to allow the Owner to provide its Service, comply with its legal obligations, respond to enforcement requests, protect its rights and interests (or those of its Users or third parties), detect any malicious or fraudulent activity, as well as the following: Analytics, Advertising, Access to third-party accounts, Remarketing and behavioral targeting, Hosting and backend infrastructure, Managing contacts and sending messages, Platform services and hosting and Backup saving and management")
                    Text("For specific information about the Personal Data used for each purpose, the User may refer to the section “Detailed information on the processing of Personal Data”.")
                }
                .fontWeight(.light)
                Group { // Facebook
                    Text("Facebook permissions asked by this Application")
                        .font(.title)
                    Text("This Application may ask for some Facebook permissions allowing it to perform actions with the User's Facebook account and to retrieve information, including Personal Data, from it. This service allows this Application to connect with the User's account on the Facebook social network, provided by Facebook Inc.")
                    Text("For more information about the following permissions, refer to the Facebook permissions documentation and to the Facebook privacy policy.\nThe permissions asked are the following:")
                    Text("The permissions asked are the following:")
                    Text("Basic information")
                        .font(.title2)
                    Text("By default, this includes certain User’s Data such as id, name, picture, gender, and their locale. Certain connections of the User, such as the Friends, are also available. If the User has made more of their Data public, more information will be available")
                    Text("Manage Advertisements")
                        .font(.title2)
                    Text("Provides the ability to manage ads and call the Facebook Ads API on behalf of a User")
                }
                .fontWeight(.light)
                Group {
                    Text("The rights of Users")
                        .font(.title)
                    Text("Users may exercise certain rights regarding their Data processed by the Owner.\nIn particular, Users have the right to do the following:\n- Withdraw their consent at any time. Users have the right to withdraw consent where they have previously given their consent to the processing of their Personal Data\n- Object to processing of their Data. Users have the right to object to the processing of their Data if the processing is carried out on a legal basis other than consent. Further details are provided in the dedicated section below\n- Access their Data. Users have the right to learn if Data is being processed by the Owner, obtain disclosure regarding certain aspects of the processing and obtain a copy of the Data undergoing processing\n- Verify and seek rectification. Users have the right to verify the accuracy of their Data and ask for it to be updated or corrected\n- Restrict the processing of their Data. Users have the right, under certain circumstances, to restrict the processing of their Data. In this case, the Owner will not process their Data for any purpose other than storing it.\n- Have their Personal Data deleted or otherwise removed. Users have the right, under certain circumstances, to obtain the erasure of their Data from the Owner\n- Receive their Data and have it transferred to another controller. Users have the right to receive their Data in a structured, commonly used and machine readable format and, if technically feasible, to have it transmitted to another controller without any hindrance. This provision is applicable provided that the Data is processed by automated means and that the processing is based on the User's consent, on a contract which the User is part of or on pre-contractual obligations thereof\n- Lodge a complaint. Users have the right to bring a claim before their competent data protection authority")
                    Text("Details about the right to object to processing")
                        .font(.title2)
                    Text("Where Personal Data is processed for a public interest, in the exercise of an official authority vested in the Owner or for the purposes of the legitimate interests pursued by the Owner, Users may object to such processing by providing a ground related to their particular situation to justify the objection")
                    Text("Users must know that, however, should their Personal Data be processed for direct marketing purposes, they can object to that processing at any time without providing any justification. To learn, whether the Owner is processing Personal Data for direct marketing purposes, Users may refer to the relevant sections of this document")
                    Text("How to exercise these rights")
                        .font(.title2)
                    Text("Any requests to exercise User rights can be directed to the Owner through the contact details provided in this document. These requests can be exercised free of charge and will be addressed by the Owner as early as possible and always within one month")
                }
                .fontWeight(.light)
                Group { // Additional information
                    Group {
                        Text("Additional information about Data collection and processing")
                            .font(.title)
                        Text("Legal action")
                            .font(.title2)
                        Text("The User's Personal Data may be used for legal purposes by the Owner in Court or in the stages leading to possible legal action arising from improper use of this Application or the related Services\nThe User declares to be aware that the Owner may be required to reveal personal data upon request of public authorities")
                        Text("Additional information about User's Personal Data")
                            .font(.title2)
                        Text("In addition to the information contained in this privacy policy, this Application may provide the User with additional and contextual information concerning particular Services or the collection and processing of Personal Data upon request.")
                        Text("System logs and maintenance")
                            .font(.title2)
                        Text("For operation and maintenance purposes, this Application and any third-party services may collect files that record interaction with this Application (System logs) use other Personal Data (such as the IP Address) for this purpose")
                    }
                    Group {
                        Text("Information not contained in this policy")
                            .font(.title2)
                        Text("More details concerning the collection or processing of Personal Data may be requested from the Owner at any time. Please see the contact information at the beginning of this document")
                        Text("How “Do Not Track” requests are handled")
                            .font(.title2)
                        Text("This Application does not support “Do Not Track” requests.\nTo determine whether any of the third-party services it uses honor the “Do Not Track” requests, please read their privacy policies")
                        Text("Changes to this privacy policy")
                            .font(.title2)
                        Text("The Owner reserves the right to make changes to this privacy policy at any time by notifying its Users on this page and possibly within this Application and/or - as far as technically and legally feasible - sending a notice to Users via any contact information available to the Owner. It is strongly recommended to check this page often, referring to the date of the last modification listed at the bottom.\n\nShould the changes affect processing activities performed on the basis of the User’s consent, the Owner shall collect new consent from the User, where required")
                    }
                }
                .fontWeight(.light)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                ToolbarBack()
            }
        }
        .onAppear(perform: {
            navigationVM.tabBarHidden = true
        })
    }
    
    @ViewBuilder
    func ToolbarBack() -> some View {
        Button(action: {
            _ = navigationVM.navigationPath.popLast()
        }, label: {
            Image(systemName: "chevron.left")
                .font(.headline)
        })
        .foregroundStyle(.primary)
    }
}

#Preview {
    PrivacyView().preferredColorScheme(.dark)
}
