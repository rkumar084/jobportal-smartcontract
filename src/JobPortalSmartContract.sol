// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;


contract JobPortal {

    enum JobType { CLERK, ATTENDER, HOUSEKEEPING}
    enum ApplicationType {CONTRACT, PARTTIME, FULLTIME}
    enum ApplicantType {SKILLED, UNSKILLED, IMMIGRANT}
    enum Rating {UNRATED, POOR, GOOD, EXCELLENT}

    address constant public admin = 0x293b3942a41051ef062DDB2cB992B0632611Bece;
    uint256 public jobIdCounter;
    uint256 public applicantIdCounter;
    uint256 public applicationIdCounter;


    struct Job {
        uint256 id; 
        string jobDescription;
        string companyName;
        address companyAddress;
        JobType jobType;
        string role;
    }

    struct Applicant {
        uint256 id; 
        string name;
        Rating[] ratings; // multiple rating provided by different employers
        string skill; 
        ApplicantType applicantType;
        address applicantAddress; 
        string experience; 
    }

    struct Application {
        uint256 applicationId; 
        uint256 jobId; 
        uint256 applicantId; 
        address applicantAddress;
        ApplicationType applicationType;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Error! Only admin can perform operation");
    _;}

    modifier isValidJobType(JobType jobType){
        require(jobType == JobType.ATTENDER || jobType == JobType.CLERK || jobType == JobType.HOUSEKEEPING, "Error! Invalid JobType");
    _;}

    modifier isValidApplicationType(ApplicationType applicationType){
        require(applicationType == ApplicationType.CONTRACT || applicationType == ApplicationType.PARTTIME || applicationType == ApplicationType.FULLTIME, "Error! Invalid ApplicationType");
    _;}

    modifier isValidRating(Rating rating){
        require(rating == Rating.UNRATED|| rating == Rating.POOR || rating == Rating.GOOD || rating == Rating.EXCELLENT, "Error! Invalid Rating");
    _;}

    modifier isValidApplicantType(ApplicantType applicantType){
        require(applicantType == ApplicantType.UNSKILLED|| applicantType == ApplicantType.SKILLED || applicantType == ApplicantType.IMMIGRANT , "Error! Invalid Applicant Type");
    _;}


    mapping(uint256 => Job)  jobMapping; 
    mapping(uint256 => Applicant)  applicantMapping; 
    mapping(uint256 => Application)  applicationMapping; 
    //mapping(JobType => uint256[]) jobTypeMapping; 

    function addJob(string memory jobDescription,string memory companyName, JobType jobType, string memory role) public isValidJobType(jobType) {
        Job memory job;
        uint256 jobId = ++jobIdCounter;
        job.jobDescription = jobDescription;
        job.companyName = companyName;
        job.companyAddress = msg.sender;
        // Error handling for jobType
        job.jobType = jobType;
        job.role = role;
        jobMapping[jobId] = job;
    }

	function addApplicant(string memory name, string memory skill, string memory experience, ApplicantType applicantType, address applicantAddress) public onlyAdmin isValidApplicantType(applicantType) {
        uint256 id = ++applicantIdCounter; 
        Applicant storage applicant = applicantMapping[id];
        applicant.id = id;
        applicant.name = name;
        applicant.skill = skill;
        applicant.experience = experience;
        applicant.applicantType = applicantType;
        applicant.applicantAddress = applicantAddress;
        //applicantMapping[id] = applicant;  
    }

    function provideRating(uint256 applicantId, Rating rating) public isValidRating(rating){
        Applicant storage applicant = applicantMapping[applicantId];
        applicant.ratings.push(rating);
        //applicantMapping[applicantId] = applicant;
    }

    function applyForJob(uint256 jobId, uint256 applicantId, ApplicationType applicationType) public isValidApplicationType(applicationType) {
        Application memory application;
        uint256 applicationId = ++applicationIdCounter;
        application.applicantId = applicantId;
        application.jobId = jobId;
        application.applicationId = applicationId;
        application.applicationType = applicationType;
        applicationMapping[applicationId] = application;
    }

    function getJobDetails(uint256 jobId) public view returns (string memory, string memory, address companyAddress, JobType, string memory) {
        Job memory job = jobMapping[jobId];
        return (job.jobDescription, job.companyName, job.companyAddress, job.jobType, job.role);
    }

	function getApplicantDetails(uint256 applicantId) public view returns (string memory, string memory, string memory) {
        Applicant memory applicant = applicantMapping[applicantId];
        return (applicant.name, applicant.skill, applicant.experience);
    }

	function getApplication(uint256 applicationId)	public view returns (uint256, uint256, ApplicationType) {
        Application memory application = applicationMapping[applicationId];
        return (application.jobId, application.applicantId, application.applicationType);
    }

	function fetchApplicantRating(uint256 applicantId) public view returns (Rating[] memory) {
        Applicant memory applicant = applicantMapping[applicantId];
        return (applicant.ratings);
    }
} 