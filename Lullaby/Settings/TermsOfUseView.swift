//
//  TermsOfUseView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 08/05/24.
//

import SwiftUI

struct TermsOfUseView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Terms Of Use")
                        .font(.title)
                    Text("These Terms govern\n- the use of this Application, and.\n- any other related Agreement or legal relationship with the Owner\nin a legally binding way. Capitalized words are defined in the relevant dedicated section of this document\n\nThe User must read this document carefully")
                    Text("**Owner contact email:** `Krutov89@bk.ru`")
                    Text("What the User should know at a glance")
                        .font(.title)
                    Text("Please note that some provisions in these Terms may only apply to certain categories of Users. In particular, certain provisions may only apply to Consumers or to those Users that do not qualify as Consumers. Such limitations are always explicitly mentioned within each affected clause. In the absence of any such mention, clauses apply to all Users")
                    Text("TERMS OF USE")
                        .font(.title)
                    Text("Unless otherwise specified, the terms of use detailed in this section apply generally when using this Application.\nSingle or additional conditions of use or access may apply in specific scenarios and in such cases are additionally indicated within this document.\nBy using this Application, Users confirm to meet the following requirements:\n- There are no restrictions for Users in terms of being Consumers or Business Users")
                    Text("Content on this Application")
                        .font(.title)
                    Text("Unless where otherwise specified or clearly recognizable, all content available on this Application is owned or provided by the Owner or its licensors.\nThe Owner undertakes its utmost effort to ensure that the content provided on this Application infringes no applicable legal provisions or third-party rights. However, it may not always be possible to achieve such a result.\nIn such cases, without prejudice to any legal prerogatives of Users to enforce their rights, Users are kindly asked to preferably report related complaints using the contact details provided in this document")
                    Text("Rights regarding content on this Application - All rights reserved")
                        .bold()
                    Text("The Owner holds and reserves all intellectual property rights for any such content.\nUsers may not therefore use such content in any way that is not necessary or implicit in the proper use of the Service.\nIn particular, but without limitation, Users may not copy, download, share (beyond the limits set forth below), modify, translate, transform, publish, transmit, sell, sublicense, edit, transfer/assign to third parties or create derivative works from the content available on this Application, nor allow any third party to do so through the User or their device, even without the User's knowledge.\nWhere explicitly stated on this Application, the User may download, copy and/or share some content available through this Application for its sole personal and non-commercial use and provided that the copyright attributions and all the other attributions requested by the Owner are correctly implemented.\nAny applicable statutory limitation or exception to copyright shall stay unaffected")
                    Text("Access to external resources")
                        .font(.title2)
                }
                Group {
                    Text("Through this Application Users may have access to external resources provided by third parties. Users acknowledge and accept that the Owner has no control over such resources and is therefore not responsible for their content and availability.\nConditions applicable to any resources provided by third parties, including those applicable to any possible grant of rights in content, result from each such third parties’ terms and conditions or, in the absence of those, applicable statutory law")
                    Text("Acceptable use")
                        .font(.title2)
                    Text("This Application and the Service may only be used within the scope of what they are provided for, under these Terms and applicable law.\nUsers are solely responsible for making sure that their use of this Application and/or the Service violates no applicable law, regulations or third-party rights.\nTherefore, the Owner reserves the right to take any appropriate measure to protect its legitimate interests including by denying Users access to this Application or the Service, terminating contracts, reporting any misconduct performed through this Application or the Service to the competent authorities – such as judicial or administrative authorities - whenever Users engage or are suspected to engage in any of the following activities:\n- violate laws, regulations and/or these Terms;\n- infringe any third-party rights;\n- considerably impair the Owner’s legitimate interests;\n- offend the Owner or any third party")
                    Text("API usage terms")
                        .font(.title2)
                    Text("Users may access their data relating to this Application via the Application Program Interface (API). Any use of the API, including use of the API through a third-party product/service that accesses this Application, is bound by these Terms and, in addition, by the following specific terms:\n- the User expressly understands and agrees that the Owner bears no responsibility and shall not be held liable for any damages or losses resulting from the User’s use of the API or their use of any third-party products/services that access data through the API")
                    Text("Liability and indemnification")
                        .font(.title)
                    Text("Australian Users")
                        .font(.title2)
                    Text("Limitation of liability").bold()
                    Text("Nothing in these Terms excludes, restricts or modifies any guarantee, condition, warranty, right or remedy which the User may have under the Competition and Consumer Act 2010 (Cth) or any similar State and Territory legislation and which cannot be excluded, restricted or modified (non-excludable right). To the fullest extent permitted by law, our liability to the User, including liability for a breach of a non-excludable right and liability which is not otherwise excluded under these Terms of Use, is limited, at the Owner’s sole discretion, to the re-performance of the services or the payment of the cost of having the services supplied again")
                    Text("US Users")
                        .font(.title2)
                    Text("Disclaimer of Warranties\nThis Application is provided strictly on an “as is” and “as available” basis. Use of the Service is at Users’ own risk. To the maximum extent permitted by applicable law, the Owner expressly disclaims all conditions, representations, and warranties — whether express, implied, statutory or otherwise, including, but not limited to, any implied warranty of merchantability, fitness for a particular purpose, or non-infringement of third-party rights. No advice or information, whether oral or written, obtained by user from owner or through the Service will create any warranty not expressly stated herein.\nWithout limiting the foregoing, the Owner, its subsidiaries, affiliates, licensors, officers, directors, agents, co-branders, partners, suppliers and employees do not warrant that the content is accurate, reliable or correct; that the Service will meet Users’ requirements; that the Service will be available at any particular time or location, uninterrupted or secure; that any defects or errors will be corrected; or that the Service is free of viruses or other harmful components. Any content downloaded or otherwise obtained through the use of the Service is downloaded at users own risk and users shall be solely responsible for any damage to Users’ computer system or mobile device or loss of data that results from such download or Users’ use of the Service.\nThe Owner does not warrant, endorse, guarantee, or assume responsibility for any product or service advertised or offered by a third party through the Service or any hyperlinked website or service, and the Owner shall not be a party to or in any way monitor any transaction between Users and third-party providers of products or services.\nThe Service may become inaccessible or it may not function properly with Users’ web browser, mobile device, and/or operating system. The owner cannot be held liable for any perceived or actual damages arising from Service content, operation, or use of this Service.\nFederal law, some states, and other jurisdictions, do not allow the exclusion and limitations of certain implied warranties. The above exclusions may not apply to Users. This Agreement gives Users specific legal rights, and Users may also have other rights which vary from state to state. The disclaimers and exclusions under this agreement shall not apply to the extent prohibited by applicable law.\nLimitations of liability\nTo the maximum extent permitted by applicable law, in no event shall the Owner, and its subsidiaries, affiliates, officers, directors, agents, co-branders, partners, suppliers and employees be liable for\n- any indirect, punitive, incidental, special, consequential or exemplary damages, including without limitation damages for loss of profits, goodwill, use, data or other intangible losses, arising out of or relating to the use of, or inability to use, the Service; and\n- any damage, loss or injury resulting from hacking, tampering or other unauthorized access or use of the Service or User account or the information contained therein;\n- any errors, mistakes, or inaccuracies of content;\n- personal injury or property damage, of any nature whatsoever, resulting from User access to or use of the Service;\n- any unauthorized access to or use of the Owner’s secure servers and/or any and all personal information stored therein;\n- any interruption or cessation of transmission to or from the Service;\n- any bugs, viruses, trojan horses, or the like that may be transmitted to or through the Service;\n- any errors or omissions in any content or for any loss or damage incurred as a result of the use of any content posted, emailed, transmitted, or otherwise made available through the Service; and/or\n- the defamatory, offensive, or illegal conduct of any User or third party. In no event shall the Owner, and its subsidiaries, affiliates, officers, directors, agents, co-branders, partners, suppliers and employees be liable for any claims, proceedings, liabilities, obligations, damages, losses or costs in an amount exceeding the amount paid by User to the Owner hereunder in the preceding 12 months, or the period of duration of this agreement between the Owner and User, whichever is shorter.\nThis limitation of liability section shall apply to the fullest extent permitted by law in the applicable jurisdiction whether the alleged liability is based on contract, tort, negligence, strict liability, or any other basis, even if company has been advised of the possibility of such damage.\nSome jurisdictions do not allow the exclusion or limitation of incidental or consequential damages, therefore the above limitations or exclusions may not apply to User. The terms give User specific legal rights, and User may also have other rights which vary from jurisdiction to jurisdiction. The disclaimers, exclusions, and limitations of liability under the terms shall not apply to the extent prohibited by applicable law.\nIndemnification\nThe User agrees to defend, indemnify and hold the Owner and its subsidiaries, affiliates, officers, directors, agents, co-branders, partners, suppliers and employees harmless from and against any and all claims or demands, damages, obligations, losses, liabilities, costs or debt, and expenses, including, but not limited to, legal fees and expenses, arising from\n- User’s use of and access to the Service, including any data or content transmitted or received by User;\n- User’s violation of these terms, including, but not limited to, User’s breach of any of the representations and warranties set forth in these terms;\n- User’s violation of any third-party rights, including, but not limited to, any right of privacy or intellectual property rights;\n- User’s violation of any statutory law, rule, or regulation;\n- any content that is submitted from User’s account, including third party access with User’s unique username, password or other security measure, if applicable, including, but not limited to, misleading, false, or inaccurate information;\n- User’s willful misconduct; or\n- statutory provision by User or its affiliates, officers, directors, agents, co-branders, partners, suppliers and employees to the extent allowed by applicable law.")
                    Text("Common provisions")
                        .font(.title)
                    Text("No Waiver")
                        .font(.title2)
                    Text("The Owner’s failure to assert any right or provision under these Terms shall not constitute a waiver of any such right or provision. No waiver shall be considered a further or continuing waiver of such term or any other term")
                    Text("Service interruption")
                        .font(.title2)
                }
                Group {
                    Text("To ensure the best possible service level, the Owner reserves the right to interrupt the Service for maintenance, system updates or any other changes, informing the Users appropriately.\nWithin the limits of law, the Owner may also decide to suspend or terminate the Service altogether. If the Service is terminated, the Owner will cooperate with Users to enable them to withdraw Personal Data or information in accordance with applicable law.\nAdditionally, the Service might not be available due to reasons outside the Owner’s reasonable control, such as “force majeure” (eg. labor actions, infrastructural breakdowns or blackouts etc).")
                    Text("Service reselling")
                        .font(.title2)
                    Text("Users may not reproduce, duplicate, copy, sell, resell or exploit any portion of this Application and of its Service without the Owner’s express prior written permission, granted either directly or through a legitimate reselling program")
                    Text("Privacy policy")
                        .font(.title2)
                    Text("To learn more about the use of their Personal Data, Users may refer to the privacy policy of this Application")
                    Text("Intellectual property rights")
                        .font(.title2)
                    Text("Without prejudice to any more specific provision of these Terms, any intellectual property rights, such as copyrights, trademark rights, patent rights and design rights related to this Application are the exclusive property of the Owner or its licensors and are subject to the protection granted by applicable laws or international treaties relating to intellectual property.\nAll trademarks — nominal or figurative — and all other marks, trade names, service marks, word marks, illustrations, images, or logos appearing in connection with this Application are, and remain, the exclusive property of the Owner or its licensors and are subject to the protection granted by applicable laws or international treaties related to intellectual property")
                    Text("Changes to these Terms")
                        .font(.title2)
                    Text("The Owner reserves the right to amend or otherwise modify these Terms at any time. In such cases, the Owner will appropriately inform the User of these changes.\nSuch changes will only affect the relationship with the User for the future.\nThe continued use of the Service will signify the User’s acceptance of the revised Terms. If Users do not wish to be bound by the changes, they must stop using the Service. Failure to accept the revised Terms, may entitle either party to terminate the Agreement.\nThe applicable previous version will govern the relationship prior to the User's acceptance. The User can obtain any previous version from the Owner.\nIf required by applicable law, the Owner will specify the date by which the modified Terms will enter into force")
                    Text("Assignment of contract")
                        .font(.title2)
                    Text("The Owner reserves the right to transfer, assign, dispose of by novation, or subcontract any or all rights or obligations under these Terms, taking the User’s legitimate interests into account. Provisions regarding changes of these Terms will apply accordingly.\nUsers may not assign or transfer their rights or obligations under these Terms in any way, without the written permission of the Owner")
                    Text("Contacts")
                        .font(.title2)
                    Text("All communications relating to the use of this Application must be sent using the contact information stated in this document")
                    Text("Severability")
                        .font(.title2)
                    Text("Should any provision of these Terms be deemed or become invalid or unenforceable under applicable law, the invalidity or unenforceability of such provision shall not affect the validity of the remaining provisions, which shall remain in full force and effect\n**US Users**")
                    Text("Any such invalid or unenforceable provision will be interpreted, construed and reformed to the extent reasonably required to render it valid, enforceable and consistent with its original intent. These Terms constitute the entire Agreement between Users and the Owner with respect to the subject matter hereof, and supersede all other communications, including but not limited to all prior agreements, between the parties with respect to such subject matter. These Terms will be enforced to the fullest extent permitted by law.\n**EU Users**")
                    Text("Should any provision of these Terms be or be deemed void, invalid or unenforceable, the parties shall do their best to find, in an amicable way, an agreement on valid and enforceable provisions thereby substituting the void, invalid or unenforceable parts.\nIn case of failure to do so, the void, invalid or unenforceable provisions shall be replaced by the applicable statutory provisions, if so permitted or stated under the applicable law.\nWithout prejudice to the above, the nullity, invalidity or the impossibility to enforce a particular provision of these Terms shall not nullify the entire Agreement, unless the severed provisions are essential to the Agreement, or of such importance that the parties would not have entered into the contract if they had known that the provision would not be valid, or in cases where the remaining provisions would translate into an unacceptable hardship on any of the parties")
                    Text("Governing law")
                        .font(.title2)
                }
                Group {
                    Text("These Terms are governed by the law of the place where the Owner is based, as disclosed in the relevant section of this document, without regard to conflict of laws principles.\n**Exception for European Consumers**\nHowever, regardless of the above, if the User qualifies as a European Consumer and has their habitual residence in a country where the law provides for a higher consumer protection standard, such higher standards shall prevail")
                    Text("Venue of jurisdiction")
                        .font(.title2)
                    Text("The exclusive competence to decide on any controversy resulting from or connected to these Terms lies with the courts of the place where the Owner is based, as displayed in the relevant section of this document.\n**Exception for European Consumers**\nThe above does not apply to any Users that qualify as European Consumers, nor to Consumers based in Switzerland, Norway or Iceland.\n`Krutov89@bk.ru`")
                }
            }
            .fontWeight(.light)
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
    TermsOfUseView()
        .preferredColorScheme(.dark)
}
