pragma solidity >=0.4.22 <0.7.0;

contract Storage{
    
    address owner_address;
    address storage_address = 0x071424020940883EAdBbe98C2b8E5876CF44E218;
    
    
    string seedName;
    string batch_id;
    uint quantity;
    uint unitPrice;
    uint optimumTemp;
    uint optimumHum;
    uint optimumLightExpo;
    uint storageDate;
    
    
    enum TempCondition {Optimum, Over, Under}
    TempCondition public tempCOn;
    
    enum HumCondition {Optimum, Over, Under}
    HumCondition public humCOn;
    
    enum LightExpoCondition {Optimum, Over, Under}
    LightExpoCondition public lightCOn;
    
    enum ViolationType{None, Temperature, Hummidity, LightExposure}
    ViolationType public violationType;
    
    constructor() internal{
        owner_address = msg.sender;
        storageDate = block.timestamp;
        tempCOn = TempCondition.Optimum;
        humCOn = HumCondition.Optimum;
        lightCOn = LightExpoCondition.Optimum;
        violationType = ViolationType.None;
    }
    
    modifier OnlyOwner(){
        require(msg.sender == owner_address);
        _;
    }
    
    modifier OnlyStorage(){
        require(msg.sender == storage_address);
        _;
    }
    
    event seedStored(address ad, string  masg);
    event TemperatureViolation(address ad, string masg);
    event HummidityViolation(address ad, string masg);
    event LightExposureViolation(address ad, string masg);
    
    
    function addSeed(
        string memory name,
        string memory bat_id,
        uint quant,
        uint price,
        uint optTem,
        uint optHum,
        uint optLitEx) private OnlyOwner{
            
        seedName = name;
        batch_id = bat_id;
        quantity = quant;
        unitPrice = price;
        optimumTemp = optTem;
        optimumHum = optHum;
        optimumLightExpo = optLitEx;
        
    }
    
    function temperatureSelfCheck(uint value) private OnlyStorage returns(string memory){
        if(value > optimumTemp){
            violationTrigger(ViolationType.Temperature, 1);
            return "Current temperature is over the threshold";
        }else if(value < optimumTemp){
            violationTrigger(ViolationType.Temperature, 0);
            return "Current temperature is below the threshold";
        }else{
            violationTrigger(ViolationType.Temperature, 2);
            return "Current temperature is optimum";
        }
    }
    
    function hummiditySelfCheck(uint value) private OnlyStorage returns(string memory){
        if(value > optimumHum){
            violationTrigger(ViolationType.Hummidity, 1);
            return "Current hummidity is over the threshold";
        }else if(value < optimumTemp){
            violationTrigger(ViolationType.Hummidity, 0);
            return "Current hummidity is below the threshold";
        }else{
            violationTrigger(ViolationType.Hummidity, 2);
            return "Current hummidity is optimum";
        }
    }
    
    function lightExpoSelfCheck(uint value) private OnlyStorage returns(string memory){
        if(value > optimumLightExpo){
            violationTrigger(ViolationType.LightExposure, 1);
            return "Current light exposure is over the threshold";
        }else if(value < optimumTemp){
            violationTrigger(ViolationType.LightExposure, 0);
            return "Current light exposure is below the threshold";
        }else{
            violationTrigger(ViolationType.None, 2);
            return "Current light exposure is optimum";
        }
    }
    
    function violationTrigger(ViolationType vio, int category) 
        private OnlyStorage{ //category 0 = under, 1 = over, 2 optimum 
        
        if(vio == ViolationType.Temperature){
            if(category == 1){
                tempCOn = TempCondition.Over;
                violationType = ViolationType.Temperature;
                emit TemperatureViolation(storage_address, "Temparature is over the threshold");  
            }else if(category == 0){
                tempCOn = TempCondition.Under;
                violationType = ViolationType.Temperature;
                emit TemperatureViolation(storage_address, "Temparature is below the threshold");
            }else if(category == 2){
                tempCOn = TempCondition.Optimum;
                violationType = ViolationType.None;
                emit TemperatureViolation(storage_address, "Temparature is Optimum");
                
            }
        }else if(vio == ViolationType.Hummidity){
            if(category == 1){
                humCOn = HumCondition.Over;
                violationType = ViolationType.Hummidity;
                emit HummidityViolation(storage_address, "Hummidity is over the threshold"); 
            }else if(category == 0){
                humCOn = HumCondition.Under;
                violationType = ViolationType.Hummidity;
                emit HummidityViolation(storage_address, "Hummidity is below the threshold");
            }else if(category == 2){
                humCOn = HumCondition.Optimum;
                violationType = ViolationType.None;
                emit HummidityViolation(storage_address, "Hummidity is Optimum");
            }
            
        }else if(vio == ViolationType.LightExposure){
            if(category == 1){
                lightCOn = LightExpoCondition.Over;
                violationType = ViolationType.LightExposure;
                emit LightExposureViolation(storage_address, "Light exposure is over the threshold");
            }else if(category == 0){
                lightCOn = LightExpoCondition.Under;
                violationType = ViolationType.LightExposure;
                emit LightExposureViolation(storage_address, "Light exposure is below the threshold");
            }else if(category == 2){
                lightCOn = LightExpoCondition.Optimum;
                violationType = ViolationType.None;
                emit LightExposureViolation(storage_address, "Light exposure is optimum");
            }
        }
    }
    
    
}