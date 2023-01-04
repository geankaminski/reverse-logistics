// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReverseLogistics {
    struct Container {
        uint256 id;
        string name;
        address owner;
        uint256 capacity;
        uint256 currentAmount;
        string status;
    }

    struct Delivery {
        uint256 id;
        address from;
        uint256 containerId;
        uint256 confirmedAmount;
        string status;
        string description;
        string ifpsUrl;
        uint256 destinationId;
    }

    struct Destination {
        address to;
        address from;
        uint256 containerId;
        string description;
        uint256 amountMeasure;
        uint256 payment;
    }

    mapping(uint256 => Container) public containers;
    mapping(uint256 => Delivery) public deliveries;
    mapping(uint256 => Destination) public destinations;

    uint256 public containerCount;
    uint256 public deliveryCount;
    uint256 public destinationCount;

    event DeliveryCreated(uint256 id);

    event DestinationCreated(uint256 id);

    event ContainerFull(uint256 id);

    function createContainer(
        string memory _name,
        uint256 _capacity,
        address _owner
    ) public {
        containerCount++;
        containers[containerCount] = Container(
            containerCount,
            _name,
            _owner,
            _capacity,
            0,
            "empty"
        );
    }

    function createDelivery(
        address _from,
        uint256 _containerId,
        uint256 _amount,
        string memory _description,
        string memory _ifpsUrl
    ) public {
        require(
            containers[_containerId].capacity >= _amount,
            "The container does not have enough capacity"
        );
        require(
            containers[_containerId].currentAmount + _amount <=
                containers[_containerId].capacity,
            "The container does not have enough capacity"
        );

        deliveryCount++;
        deliveries[deliveryCount] = Delivery(
            deliveryCount,
            _from,
            _containerId,
            _amount,
            "created",
            _description,
            _ifpsUrl,
            0
        );
        containers[_containerId].currentAmount += _amount;

        emit DeliveryCreated(deliveryCount);

        if (
            containers[_containerId].currentAmount ==
            containers[_containerId].capacity
        ) {
            containers[_containerId].status = "full";
            emit ContainerFull(_containerId);
        } else {
            containers[_containerId].status = "partial";
        }

        // call another contract to transfer crypto
    }

    function createDestination(
        address _to,
        address _from,
        uint256 _containerId,
        string memory _description,
        uint256 _amountMeasure,
        uint256 _payment
    ) public {
        require(
            stringsEquals(containers[_containerId].status, "full"),
            "The container is not full"
        );

        destinationCount++;
        destinations[destinationCount] = Destination(
            _to,
            _from,
            _containerId,
            _description,
            _amountMeasure,
            _payment
        );

        emit DestinationCreated(destinationCount);

        containers[_containerId].status = "empty";
        containers[_containerId].currentAmount = 0;

        for (uint256 i = 1; i <= deliveryCount; i++) {
            if (deliveries[i].containerId == _containerId) {
                deliveries[i].status = "delivered";
                deliveries[i].destinationId = destinationCount;
            }
        }
    }

    function getContainersByOwner(address _owner)
        public
        view
        returns (Container[] memory)
    {
        Container[] memory result = new Container[](containerCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= containerCount; i++) {
            if (containers[i].owner == _owner) {
                result[counter] = containers[i];
                counter++;
            }
        }
        return result;
    }

    function listContainersOwners() public view returns (address[] memory) {
        address[] memory result = new address[](containerCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= containerCount; i++) {
            result[counter] = containers[i].owner;
            counter++;
        }
        return result;
    }

    function getDeliveriesByContainer(uint256 _containerId)
        public
        view
        returns (Delivery[] memory)
    {
        Delivery[] memory result = new Delivery[](deliveryCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= deliveryCount; i++) {
            if (deliveries[i].containerId == _containerId) {
                result[counter] = deliveries[i];
                counter++;
            }
        }
        return result;
    }

    function getAllContainers() public view returns (Container[] memory) {
        Container[] memory result = new Container[](containerCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= containerCount; i++) {
            result[counter] = containers[i];
            counter++;
        }
        return result;
    }

    function getAllDeliveriesFromContainer(uint256 _containerId)
        public
        view
        returns (Delivery[] memory)
    {
        Delivery[] memory result = new Delivery[](deliveryCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= deliveryCount; i++) {
            if (deliveries[i].containerId == _containerId) {
                result[counter] = deliveries[i];
                counter++;
            }
        }
        return result;
    }

    function getAllDeliveries() public view returns (Delivery[] memory) {
        Delivery[] memory result = new Delivery[](deliveryCount);
        uint256 counter = 0;
        for (uint256 i = 1; i <= deliveryCount; i++) {
            result[counter] = deliveries[i];
            counter++;
        }
        return result;
    }

    function stringsEquals(string memory s1, string memory s2)
        private
        pure
        returns (bool)
    {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);

        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;

        for (uint256 i = 0; i < l1; i++) {
            if (b1[i] != b2[i]) return false;
        }

        return true;
    }
}
