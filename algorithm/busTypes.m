clearvars elems obstacleBus cartbus
elems(1) = Simulink.BusElement;
elems(1).Name = 'px';
elems(2).Name = 'py';
cartBus = Simulink.Bus;
cartBus.Elements = elems;

elems(3).Name = 'vx';
elems(4).Name = 'vy';
elems(5).Name = 'tracking';
elems(5).DataType = 'boolean';
obstacleBus = Simulink.Bus;
obstacleBus.Elements = elems;

clearvars elems