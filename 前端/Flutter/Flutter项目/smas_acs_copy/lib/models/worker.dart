import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Worker {
  int cardHolderId;
  String lastUpdateDate;
  String lastUpdatedBy;
  String cardVersionId;
  String smartCardId;
  String statusId;
  String hkid;
  String safetyCardNo;
  String expiryDate;
  String empTypeId;
  String creationDate;
  String createdBy;
  String cardIssuedDate;
  String cardIssuedBy;
  String englishName;
  String chineseName;
  String genderId;
  String phone;
  String mobile;
  String dateOfBirth;
  String address1;
  String contactPerson;
  String contactPhone;
  String selfEmploy;
  String cardIssuedTo;
  String jobNatureId;
  String employmentContract;
  String siteId;
  String subContractorId;
  String depositWaived;
  String adminChargeId;
  String bgColorId;
  String scExpiryDate;
  String cwraCardNo;
  String ccExpiryDate;
  String cwraCardSerialNo;
  String cwraCardStatusId;
  String driver;
  WorkerAccessRight workerAccessRight;
  WorkerMedicalTest workerMedicalTest;
  String status;
  String statusDesc;

  Worker(
      {this.cardHolderId,
      this.lastUpdateDate,
      this.lastUpdatedBy,
      this.cardVersionId,
      this.smartCardId,
      this.statusId,
      this.hkid,
      this.safetyCardNo,
      this.expiryDate,
      this.empTypeId,
      this.creationDate,
      this.createdBy,
      this.cardIssuedDate,
      this.cardIssuedBy,
      this.englishName,
      this.chineseName,
      this.genderId,
      this.phone,
      this.mobile,
      this.dateOfBirth,
      this.address1,
      this.contactPerson,
      this.contactPhone,
      this.selfEmploy,
      this.cardIssuedTo,
      this.jobNatureId,
      this.employmentContract,
      this.siteId,
      this.subContractorId,
      this.depositWaived,
      this.adminChargeId,
      this.bgColorId,
      this.scExpiryDate,
      this.cwraCardNo,
      this.ccExpiryDate,
      this.cwraCardSerialNo,
      this.cwraCardStatusId,
      this.driver,
      this.workerAccessRight,
      this.workerMedicalTest,
      this.status,
      this.statusDesc});

  Worker.fromJson(Map<String, dynamic> json) {
    cardHolderId = json['cardHolderId'];
    lastUpdateDate = json['lastUpdateDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
    cardVersionId = json['cardVersionId'];
    smartCardId = json['smartCardId'];
    statusId = json['statusId'];
    hkid = json['hkid'];
    safetyCardNo = json['safetyCardNo'];
    expiryDate = json['expiryDate'];
    empTypeId = json['empTypeId'];
    creationDate = json['creationDate'];
    createdBy = json['createdBy'];
    cardIssuedDate = json['cardIssuedDate'];
    cardIssuedBy = json['cardIssuedBy'];
    englishName = json['englishName'];
    chineseName = json['chineseName'];
    genderId = json['genderId'];
    phone = json['phone'];
    mobile = json['mobile'];
    dateOfBirth = json['dateOfBirth'];
    address1 = json['address1'];
    contactPerson = json['contactPerson'];
    contactPhone = json['contactPhone'];
    selfEmploy = json['selfEmploy'];
    cardIssuedTo = json['cardIssuedTo'];
    jobNatureId = json['jobNatureId'];
    employmentContract = json['employmentContract'];
    siteId = json['siteId'];
    subContractorId = json['subContractorId'];
    depositWaived = json['depositWaived'];
    adminChargeId = json['adminChargeId'];
    bgColorId = json['bgColorId'];
    scExpiryDate = json['scExpiryDate'];
    cwraCardNo = json['cwraCardNo'];
    ccExpiryDate = json['ccExpiryDate'];
    cwraCardSerialNo = json['cwraCardSerialNo'];
    cwraCardStatusId = json['cwraCardStatusId'];
    driver = json['driver'];
    workerAccessRight = json['workerAccessRight'] != null
        ? new WorkerAccessRight.fromJson(json['workerAccessRight'])
        : null;
    workerMedicalTest = json['workerMedicalTest'] != null
        ? new WorkerMedicalTest.fromJson(json['workerMedicalTest'])
        : null;
    status = json['status'];
    statusDesc = json['statusDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardHolderId'] = this.cardHolderId;
    data['lastUpdateDate'] = this.lastUpdateDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['cardVersionId'] = this.cardVersionId;
    data['smartCardId'] = this.smartCardId;
    data['statusId'] = this.statusId;
    data['hkid'] = this.hkid;
    data['safetyCardNo'] = this.safetyCardNo;
    data['expiryDate'] = this.expiryDate;
    data['empTypeId'] = this.empTypeId;
    data['creationDate'] = this.creationDate;
    data['createdBy'] = this.createdBy;
    data['cardIssuedDate'] = this.cardIssuedDate;
    data['cardIssuedBy'] = this.cardIssuedBy;
    data['englishName'] = this.englishName;
    data['chineseName'] = this.chineseName;
    data['genderId'] = this.genderId;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['dateOfBirth'] = this.dateOfBirth;
    data['address1'] = this.address1;
    data['contactPerson'] = this.contactPerson;
    data['contactPhone'] = this.contactPhone;
    data['selfEmploy'] = this.selfEmploy;
    data['cardIssuedTo'] = this.cardIssuedTo;
    data['jobNatureId'] = this.jobNatureId;
    data['employmentContract'] = this.employmentContract;
    data['siteId'] = this.siteId;
    data['subContractorId'] = this.subContractorId;
    data['depositWaived'] = this.depositWaived;
    data['adminChargeId'] = this.adminChargeId;
    data['bgColorId'] = this.bgColorId;
    data['scExpiryDate'] = this.scExpiryDate;
    data['cwraCardNo'] = this.cwraCardNo;
    data['ccExpiryDate'] = this.ccExpiryDate;
    data['cwraCardSerialNo'] = this.cwraCardSerialNo;
    data['cwraCardStatusId'] = this.cwraCardStatusId;
    data['driver'] = this.driver;
    if (this.workerAccessRight != null) {
      data['workerAccessRight'] = this.workerAccessRight.toJson();
    }
    if (this.workerMedicalTest != null) {
      data['workerMedicalTest'] = this.workerMedicalTest.toJson();
    }
    data['status'] = this.status;
    data['statusDesc'] = this.statusDesc;
    return data;
  }
}

class WorkerAccessRight {
  int cardHolderId;
  String siteId;
  String effectiveDate;
  String effectiveDateTo;
  String lastUpdateDate;
  String lastUpdatedBy;
  String vendorId;
  String jobNatureId;
  String creationDate;
  String createdBy;
  String contractId;
  String subContractorId;
  String selfEmploy;
  String empTypeId;
  String safetyPositionId;
  int basicSalary;
  String arStatusId;
  String extensionDate;
  String extendedBy;
  String jobTitleId;
  String tradeId;
  String practisingTrade;
  String tradeDesc;
  String vendorDesc;

  WorkerAccessRight(
      {this.cardHolderId,
      this.siteId,
      this.effectiveDate,
      this.effectiveDateTo,
      this.lastUpdateDate,
      this.lastUpdatedBy,
      this.vendorId,
      this.jobNatureId,
      this.creationDate,
      this.createdBy,
      this.contractId,
      this.subContractorId,
      this.selfEmploy,
      this.empTypeId,
      this.safetyPositionId,
      this.basicSalary,
      this.arStatusId,
      this.extensionDate,
      this.extendedBy,
      this.jobTitleId,
      this.tradeId,
      this.practisingTrade,
      this.tradeDesc,
      this.vendorDesc});

  WorkerAccessRight.fromJson(Map<String, dynamic> json) {
    cardHolderId = json['cardHolderId'];
    siteId = json['siteId'];
    effectiveDate = json['effectiveDate'];
    effectiveDateTo = json['effectiveDateTo'];
    lastUpdateDate = json['lastUpdateDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
    vendorId = json['vendorId'];
    jobNatureId = json['jobNatureId'];
    creationDate = json['creationDate'];
    createdBy = json['createdBy'];
    contractId = json['contractId'];
    subContractorId = json['subContractorId'];
    selfEmploy = json['selfEmploy'];
    empTypeId = json['empTypeId'];
    safetyPositionId = json['safetyPositionId'];
    basicSalary = json['basicSalary'];
    arStatusId = json['arStatusId'];
    extensionDate = json['extensionDate'];
    extendedBy = json['extendedBy'];
    jobTitleId = json['jobTitleId'];
    tradeId = json['tradeId'];
    practisingTrade = json['practisingTrade'];
    tradeDesc = json['tradeDesc'];
    vendorDesc = json['vendorDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardHolderId'] = this.cardHolderId;
    data['siteId'] = this.siteId;
    data['effectiveDate'] = this.effectiveDate;
    data['effectiveDateTo'] = this.effectiveDateTo;
    data['lastUpdateDate'] = this.lastUpdateDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['vendorId'] = this.vendorId;
    data['jobNatureId'] = this.jobNatureId;
    data['creationDate'] = this.creationDate;
    data['createdBy'] = this.createdBy;
    data['contractId'] = this.contractId;
    data['subContractorId'] = this.subContractorId;
    data['selfEmploy'] = this.selfEmploy;
    data['empTypeId'] = this.empTypeId;
    data['safetyPositionId'] = this.safetyPositionId;
    data['basicSalary'] = this.basicSalary;
    data['arStatusId'] = this.arStatusId;
    data['extensionDate'] = this.extensionDate;
    data['extendedBy'] = this.extendedBy;
    data['jobTitleId'] = this.jobTitleId;
    data['tradeId'] = this.tradeId;
    data['practisingTrade'] = this.practisingTrade;
    data['tradeDesc'] = this.tradeDesc;
    data['vendorDesc'] = this.vendorDesc;
    return data;
  }
}

class WorkerMedicalTest {
  int cardHolderId;
  String medicalTestId;
  String effectiveDate;
  String result;
  String lastUpdateDate;
  String lastUpdatedBy;
  String creationDate;
  String createdBy;
  String remark;
  String reportDate;
  String resultImgPath;
  int uploadId;
  String medicalTestDesc;
  String etfToDate;

  WorkerMedicalTest(
      {this.cardHolderId,
      this.medicalTestId,
      this.effectiveDate,
      this.result,
      this.lastUpdateDate,
      this.lastUpdatedBy,
      this.creationDate,
      this.createdBy,
      this.remark,
      this.reportDate,
      this.resultImgPath,
      this.uploadId,
      this.medicalTestDesc,
      this.etfToDate});

  WorkerMedicalTest.fromJson(Map<String, dynamic> json) {
    cardHolderId = json['cardHolderId'];
    medicalTestId = json['medicalTestId'];
    effectiveDate = json['effectiveDate'];
    result = json['result'];
    lastUpdateDate = json['lastUpdateDate'];
    lastUpdatedBy = json['lastUpdatedBy'];
    creationDate = json['creationDate'];
    createdBy = json['createdBy'];
    remark = json['remark'];
    reportDate = json['reportDate'];
    resultImgPath = json['resultImgPath'];
    uploadId = json['uploadId'];
    medicalTestDesc = json['medicalTestDesc'];
    etfToDate = json['etfToDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardHolderId'] = this.cardHolderId;
    data['medicalTestId'] = this.medicalTestId;
    data['effectiveDate'] = this.effectiveDate;
    data['result'] = this.result;
    data['lastUpdateDate'] = this.lastUpdateDate;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['creationDate'] = this.creationDate;
    data['createdBy'] = this.createdBy;
    data['remark'] = this.remark;
    data['reportDate'] = this.reportDate;
    data['resultImgPath'] = this.resultImgPath;
    data['uploadId'] = this.uploadId;
    data['medicalTestDesc'] = this.medicalTestDesc;
    data['etfToDate'] = this.etfToDate;
    return data;
  }
}
