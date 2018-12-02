<h4> Why RPC </h4>
<ul>
  <li> RPC and SMB are similar in that they both allow for remote access to systems. </li>
  <li> SMB is mostly concerned with files and how to move and interact withthem remotely. </li>
  <li> RPC is more concered with running commands on a remote system.</li>
</ul>
<h4> Perequisites </h4>
<ul>
  <li> RUnning Domain Controller (DC_ with Active Directory (AD).</li>
  <li> Windows Workstation (any version of normal WIndows Desktop) joined to your domain. </li>
  <li> At least one domain user account in AD. </li>
  </ul>
  
  <h4> Enable Remote Procedure Calls via Group Policy </h4>
      <h5> Group Policy </h5>
        <ul> 
        <li> In your Windows 10 workstation, open Group Policy editor and create a new Group Policy Object. </li>
        <li> Computer Configuration -> Policies -> Windows Settings -> Security Settings -> 
        Windows firewall with Advanced Security -> Windows Firewall with Advanced Security (again) ->
        Inbound rules </li>
        <h6> Two inbound rules need to be created </h6>
        <li> New rule -> Custom -> All Programs </li>
        <li> Protocol Type -> TCP </li>
        <li> Local ports -> RPC Dynamic Ports </li>
        <h6> Apply this rule to the domain and run 'gpudate' or restart your workstation to take affect.</h6>
        </ul>
  <h4> Challenges </h4>
  <ul> 
      <li> Launch Internet Explorer on the workstation. </li>
      <li> The goal is to kill Internet Explorer from the Domain Controller. </li>
      <li> An example command to run to help: </li>
      <li> 'tasklist /s [name of workstation] '</li>
      <h6> This will print out the list of current running processes on the remote machine.
      Use this information to kill the active Internet Explorer session. </h6>
  </ul>
  <h3> Please be aware! </h3>
  <h4> RPC is very dangerous if not being used for legitimate purposes!!! </h4>
  <p> In the competition we may want to disable this type of connection, if no other services are used it.
  To do this, you can modify the current group policy objects to block the connection.</p>
  <p> If there are no group policy objects by default, new objects can be made that block the connection.
  This is the same process as creating the objects defined above but instead of allowing the connections they are blocked. </p>
